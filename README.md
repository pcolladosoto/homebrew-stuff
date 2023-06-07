# My Homebrew Tap
[Homebrew](https://brew.sh) formulae and/or casks are sometime updated in such a way that things
break. On other occasions, [`homebrew-core`](https://github.com/Homebrew/homebrew-core) suddenly drops
some formulae when the associated tool updates too often for instance.

In some occasions the developers offer their own [tap](https://docs.brew.sh/Taps), but in others
that's not the case. It is exactly for placating this latter scenario that we built our tap. We
can now control what we can install and, more importantly, **how** we install it.

You might find something of interest here or you might just find this interesting as an example
for setting up your own tap. Be it what it may, we hope you enjoy taking a look around.

## Available casks
- `etcher`: A flashing tool for SD cards and USB drives. Be sure to check [their site](https://etcher.balena.io).

## Available formulae
- `botan2`: Latest `2.x` version of the [`botan`](https://botan.randombit.net) library implementing cryptography and TLS
  primitives for C++.

## How do I install these formulae?
We just need to make the use of this tap explicit when passing the formula name as an argument to `brew`:

    $ brew install pcolladosoto/stuff/<formula>

We can also **install** the tap (i.e. add it to our local `brew` client) and then install available casks or formulae:

    # We can add the tap...
    $ brew tap pcolladosoto/stuff

    # And then install stuff as we would usually do:
    $ brew install <formula>

## Removing the tap
Luckily, removing the tap is just as easy as installing it. The following will do the trick:

    $ brew untap pcolladosoto/stuff

## My local setup
We actually cloned the repo into the following directory so that we can install formulae and casks **before** pushing
changes to the repo:

    $ git clone git@github.com:pcolladosoto/homebrew-stuff.git /usr/local/Homebrew/Library/Taps/pcolladosoto/homebrew-stuff

We then added a symbolic link so that we could access the tap in an easier fashion:

    $ ln -s /usr/local/Homebrew/Library/Taps/pcolladosoto/homebrew-stuff ~/somewhere/nice

## Documentation
You can read up more on `brew` by taking a look at `brew(1)` (with `man brew`) or by taking a look at the
[online docs](https://docs.brew.sh).
