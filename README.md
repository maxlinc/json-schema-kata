# json-schema-kata

> **[JSON Schema](http://json-schema.org/)** describes your JSON data format

and

> Code Kata is an attempt to bring this element of practice to software development. A kata is an exercise in karate where you repeat a form many, many times, making little improvements in each. The intent behind code kata is similar.
> 
> Dave Thomas [Code Kata](http://codekata.pragprog.com/2007/01/code_kata_backg.html)

## What?

It's a challenge.  It's like [FizzBuzz](http://c2.com/cgi/wiki?FizzBuzzTest), but a bit harder.  It's an incremental challenge - you can try to make all the tests pass, or just the simpler features.

It is not tied to any language or paradigm.  You need ruby to run the tests, but you can implement your solution in any language.  Try [Seven Languages in Seven Weeks](http://pragprog.com/book/btlang/seven-languages-in-seven-weeks).  Try [thinking functionally](http://www.ibm.com/developerworks/library/j-ft1/).  Try creating a [Domain-Specific Language](http://martinfowler.com/books/dsl.html).

Remember to let them know at [json-schema.org](http://json-schema.org/) if you come up with an implementation you want to share!

## How?

You just need to create a script for each challenge.  If you don't have a script for a given challenge, the test will be marked as "pending".  If you have a script, json-schema-kata will check your results.

The current challenges are:
- `scripts/challenges/generate_draft3`
- `scripts/challenges/generate_draft4`

json-schema-kata will call your script with one argument: a file containing example json.

You can put anything executable in the script, whether it's a wrapper to a command-line program or a program that invokes your API.

If you're confused, see [json-schema-generator](https://github.com/maxlinc/json-schema-generator) as an example.

## Running tests

- bundle install
- bundle exec rake

The tests check if implementations:

* **Detecting optional properties:** if you have an array of hashes, then will detect which hash keys exist in every instance of the hash and which ones only exist in some, and use this data to decide if the key is required or optional in the schema.
* **Assume required:** in all other cases, I assume everything I find in the sample is required.  I believe it is better to generate a schema that is too strict than too lenient.  It is easy to review and fix false negatives, by updating the schema to mark those items as optional.  A false positive will go unnoticed and will not point you towards a solution.
* **Array assumptions:** Similarly, I assume arrays must have at least 1 element, unless the sample contains an empty array.  Again, this is to create false negatives instead of false positives.
* **Detect types:** I detect objects, arrays, strings, integers, numbers and booleans.
* **Description:** generates a description indicating what sample the schema came from.  Useful to determine if differences between and existing and freshly generated schema are from customizations or because the sample data has changed.  Sample description: *"Generated from spec/fixtures/examples/servers.json with shasum 568cdaa5cef13f7b5ece95a9dc6d65460d8362ba"*
* **Versions:** Generate both draft3 and draft4.

## Why?

I wrote [json-schema-generator](https://github.com/maxlinc/json-schema-generator) in Ruby because I needed some schemas and couldn't find a generator.  There are [many json-schema validators], but only a few generators.  The project has saved me a lot of time.  I'm proud of the end result, but I know the implementation can be improved.  I seperated the tests from the implementation, so I could challenge myself to write a better implementation that achieves the same goals.  Or to write other implementations to learn new skills.  I made a kata.

## Contributing

It's easy to add tests.  Just add some sample data in `spec/fixtures/examples`, and what you think the results should look like under `spec/fixtures/schemas`.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
