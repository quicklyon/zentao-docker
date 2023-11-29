#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find /opt/zbox "$ZBOX_ROOT_DIR" -name '*.sh' )

for file in "${files[@]}"; do
  if [[ -n $EXCLUDE_PATHS ]] && [[ "$file" =~ $EXCLUDE_PATHS ]]; then
    continue
  fi
  [[ $(grep -cE "sed -i|sed --in-place" "$file") -eq 0 ]] || exit 1
done
