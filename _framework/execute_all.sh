#!/bin/bash

ls -1d ../testcases/T*/ | xargs -I {} bash -c "cd {} && ./execute_test.sh $1" 
