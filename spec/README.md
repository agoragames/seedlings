## Running Specs

By default, we run the specs with mongomapper. To run them with mongoid or sqlite, use: `DB=mongoid rspec spec`. Make sure you have the requisite table set up for the SQL-based test.

Taking our cues from seed-fu, I've placed the connection and model setup stuff out in `spec/connections/*`.
