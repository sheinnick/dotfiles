#!/bin/sh
(
  cd ansible
  ansible-galaxy install -r requirements.yml
  ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_all.yml --skip-tags work
  ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_secutiry.yml
)