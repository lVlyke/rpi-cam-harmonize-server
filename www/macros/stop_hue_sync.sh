#!/bin/bash

screen 1>&2 -XS hue-sync-tty stuff "q\n"
sleep 5
screen 1>&2 -XS hue-sync-tty stuff "exit\n"
