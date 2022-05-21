# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Lexicon::Application.config.secret_key_base = '5cfc23c730181c64b2bb765adb0e4df43d325a7894ddd18ea7a39d4d0831f51ce91d51fd5445e2d5aedd40b573c77465d1a7fbd2b733a4db69de53db4d3bed64'
