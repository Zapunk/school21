#!/bin/bash
URL="https://api.telegram.org/bot8151101842:AAFWG_By3cqpmhoW0O-2r9Ba2Km6ccFXsPw/sendMessage"
TEXT="Deploy status: $1%0A%0AProject:+$CI_PROJECT_NAME%0AURL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/%0ABranch:+$CI_COMMIT_REF_SLUG"

curl -s -d "chat_id=1306744343&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null
