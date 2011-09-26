## Running Specs

By default, we run the specs with mongomapper. To run them with mongoid or sqlite, use: `DB=mongoid rspec spec` or `DB=sqlite rspec spec`. SQLite is super easy and should require 0 setup. #winning!

Taking our cues from seed-fu, I've placed the connection and model setup stuff out in `spec/connections/*`.
