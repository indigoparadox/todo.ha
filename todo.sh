#!/bin/bash

#!/usr/bin/bash

if [ -z "$HA_URL" ]; then
   echo "$$HA_URL must be set to Home Assistant instance URL!"
   exit 1
fi

HA_KEY="$(keyring get "$HA_URL" "$(whoami)")"
if [ -z "$HA_KEY" ]; then
   echo "Bearer token must be set with: keyring set \"$$HA_URL\" \"$$\(whoami\)\""
   exit 1
fi

HA_LIST_DEFAULT="todo.default_list"
if [ -z "$HA_LIST" ]; then
   HA_LIST="$HA_LIST_DEFAULT"
fi

if [ -z "$1" ]; then
   echo "No command specified!"
   exit 1
else
   HA_CMD="$1"
fi

function ha_todo_add() {
   HA_LIST=$1
   HA_ITEM=$2
   curl -s \
      -H "Authorization: Bearer $HA_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"entity_id\": \"$HA_LIST\", \"item\": \"$HA_ITEM\"}" \
      "$HA_URL/api/services/todo/add_item"
   echo
}

function ha_todo_list() {
   HA_LIST=$1
   HA_ITEM=$2
   curl -s \
      -H "Authorization: Bearer $HA_KEY" \
      -H "Content-Type: application/json" \
      "$HA_URL/api/shopping_lists"
   echo
}

ha_todo_$HA_CMD "$HA_LIST" "$2"

