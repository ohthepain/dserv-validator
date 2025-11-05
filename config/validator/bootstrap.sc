import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._

def main() {
  val dars = decode[Seq[String]](sys.env.get("SPLICE_APP_DARS").getOrElse("[]")).getOrElse(
    sys.error("Failed to parse dars list")
  )
  val timeoutMinutes =
    decode[Int](sys.env.get("SPLICE_APP_INITIALIZATION_TIMEOUT_MINUTES").getOrElse("5")).getOrElse(
      sys.error("Failed to parse initialization timeout")
    )

  logger.info("Waiting for validator to finish init...")
  logger.debug(s"Loaded environment: ${sys.env}")
  validators.map(_.waitForInitialization(timeoutMinutes.minutes))

  if (dars.isEmpty) {
    logger.info("No DARs specified to upload")
  } else {
    logger.info(s"Uploading DARs: ${dars}")
    dars.foreach(d => validators.map(_.participantClient.upload_dar_unless_exists(d)))
  }

  // Note: PQS permissions are granted via HTTP API using grant-backend-permissions.sh or dwit.sh
  // The Canton console API doesn't support ReadAs permission granting directly
  logger.info("Bootstrap complete. Use grant-backend-permissions.sh or dwit.sh to grant PQS permissions.")
}
