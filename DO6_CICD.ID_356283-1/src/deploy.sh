#!/bin/bash
set -e
scp code-samples/DO spectrav@10.10.0.2:/usr/local/bin/
ssh spectrav@10.10.0.2 chmod +x  /usr/local/bin/DO
