# Submitting a pull request <!-- omit in toc -->

If you've decided to fix a bug, even something as small as a single-letter typo, then great! Anything that improves the code/documentation for all future users is warmly welcomed.

If you decide to work on a requested feature it's best to let us (and everyone else) know what you're working on to avoid any duplication of effort. You can do this by replying to the original Issue for the request.

If you want to contribute an example; go for it! We might not always be able to accept your code, but there's a lot to be learned from trying anyway. If you're new to GitHub we're willing to guide you on that journey.

When contributing a new example or making a change to a library please keep your code style consistent with ours. We try to stick to the pep8 guidelines for Python (https://www.python.org/dev/peps/pep-0008/).

- [Do](#do)
- [Don't](#dont)
- [If you're submitting an example](#if-youre-submitting-an-example)
- [Licensing](#licensing)
- [Submitting your code](#submitting-your-code)

## Do

* Use pep8 style guidelines
* Comment your code where necessary
* Submit only a single example/feature per pull-request
* Include a description of what your example is expected to do
* Add details of your example to examples/README.md if it exists

## Don't

* Don't include any license information in your examples- our repositories are MIT licensed
* Don't try to do too much at once- submit one or two examples at a time, and be receptive to feedback
* Don't submit multiple variations of the same example, demonstrate one thing concisely

## If you're submitting an example

Try to do one thing, and do it concisely. Keep it simple. Don't mix too many ideas.

The ideal example should:

* Demonstrate one idea, technique or API as concisely as possible in a single Python script
* *Just work* when you run it. Although sometimes configuration is necessary
* Be well commented and attempt to teach the user how and why it works
* Document any required configuration, and how to install API keys, dependencies, etc

If you have a more complex example that uses multiple HATs/pHATs or consists of multiple files then consider submitting it as a project instead- either by creating your own GitHub repository and adding the link to the README.md, or by creating a subfolder in the projects/ directory for your code. For example:

* https://github.com/pimoroni/unicorn-hat-hd/tree/master/projects/unicornpaint
* https://github.com/pimoroni/phat-beat/tree/master/projects/vlc-radio

And don't forget to shout about your example on our forums/twitter so we can signal-boost you and let everyone know how awesome you are!

## Licensing

When you submit code to our libraries, you implicitly and irrevocably agree to adopt the associated licenses. You should be able to find this in the file named `LICENSE`.

We typically use the MIT license; which permits Commercial Use, Modification, Distribution and Private use of our code, and therefore also your contributions. It also provides good compatibility with other licenses, and is intended to make re-use of our code as painless as possible for all parties, no matter what they might do with it.

You can learn more about the MIT license at Wikipedia: https://en.wikipedia.org/wiki/MIT_License

## Submitting your code

Once you're ready to share your contribution with us you should submit it as a Pull Request.

* Be ready to receive and embrace constructive feedback.
* Be prepared for rejection; we can't always accept contributions. If you're unsure, ask first!