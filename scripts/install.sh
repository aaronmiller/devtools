#!/usr/bin/env bash

fix_compaudit() {
  compaudit | xargs chmod g-w,o-w
}
