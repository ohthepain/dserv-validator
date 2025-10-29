#!/bin/bash
set -e

curl -f http://localhost:25003/api/validator/readyz
curl -f http://localhost:35003/api/validator/readyz
