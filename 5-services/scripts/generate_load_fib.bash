#!/bin/bash
IP="143.244.214.107"
while true; do wget -q -O- ${IP}/fib; done