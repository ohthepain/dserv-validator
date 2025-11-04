import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._
import com.digitalasset.canton.ledger.api.auth.ReadAs

def main() {
  val dars = decode[Seq[String]](sys.env.get("SPLICE_APP_DARS").getOrElse("[]")).getOrElse(
    sys.error("Failed to parse dars list")
  )
  val timeoutMinutes =
    decode[Int](sys.env.get("SPLICE_APP_INITIALIZATION_TIMEOUT_MINUTES").getOrElse("5")).getOrElse(
      sys.error("Failed to parse initialization timeout")
    )
  val pqsUserId = sys.env.get("AUTH_APP_PROVIDER_PQS_USER_ID")
  val providerPartyHint = sys.env.get("APP_PROVIDER_PARTY_HINT")

  logger.info("Waiting for validator to finish init...")
  logger.debug(s"Loaded environment: ${sys.env}")
  validators.map(_.waitForInitialization(timeoutMinutes.minutes))

  if (dars.isEmpty) {
    logger.info("No DARs specified to upload")
  } else {
    logger.info(s"Uploading DARs: ${dars}")
    dars.foreach(d => validators.map(_.participantClient.upload_dar_unless_exists(d)))
  }

  // Grant ReadAs permissions to PQS service account if configured
  // This should only run on the provider validator which connects to participant-provider
  logger.info("Grant rights for PQS")
  logger.info("pqsUserId: ${pqsUserId}")
  logger.info("providerPartyHint: ${providerPartyHint}")
  (pqsUserId, providerPartyHint) match {
    case (Some(userId), Some(partyHint)) =>
      logger.info(s"Granting ReadAs permissions to PQS user ${userId} for party hint ${partyHint}")
      try {
        validators.foreach { validator =>
          try {
            val participant = validator.participantClient
            // Find the party matching the hint pattern
            val parties = participant.parties.list()
            val matchingParty = parties.find(p => p.party.toString.startsWith(partyHint))
            
            matchingParty match {
              case Some(party) =>
                logger.info(s"Found party ${party.party} for hint ${partyHint} on participant ${participant.id}")
                // Grant ReadAs permission
                participant.ledger_api.users.rights.grant(userId, ReadAs(party.party))
                logger.info(s"Successfully granted ReadAs permission to PQS user ${userId} for party ${party.party}")
              case None =>
                logger.debug(s"No party found matching hint ${partyHint} on participant ${participant.id}. Skipping.")
            }
          } catch {
            case e: Exception =>
              logger.debug(s"Could not grant permissions on participant ${validator.participantClient.id}: ${e.getMessage}")
          }
        }
      } catch {
        case e: Exception =>
          logger.error(s"Failed to grant ReadAs permissions to PQS user: ${e.getMessage}", e)
      }
    case _ =>
      logger.info("PQS user ID or provider party hint not configured, skipping ReadAs permission grant")
  }
}
