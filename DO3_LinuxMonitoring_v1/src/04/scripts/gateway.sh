#!/bin/bash

echo "$(ip r | grep default | awk '{print $3}')"