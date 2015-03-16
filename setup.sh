#!/bin/bash

# remove existing folder and use git to clone the munki-enroll scripts into the munki-data volume
docker exec munki rm -rf /munki_repo/munki-enroll
docker exec munki git clone https://github.com/grahampugh/munki-enroll.git /munki_repo/munki-enroll
