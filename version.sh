#!/usr/bin/env bash
# License: MIT (https://opensource.org/licenses/MIT)
# Copyright 2017 Peter Harlacher

script_dir=$(dirname "$BASH_SOURCE")

# Define the release branch
# 
RELEASE_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$RELEASE_BRANCH" != "$CURRENT_BRANCH" ]; then
    echo -e "\033[31mNot on release branch!"
    exit 1
fi

# App config
#
APPCONFIG="$script_dir/config/_app.php"

if [ ! -f "$APPCONFIG" ]; then
    echo -e "\033[31m$APPCONFIG does not exist."
    exit 1
fi

# Bugsnag config
#
BUGSNAG=false
BUGSNAGCONFIG="$script_dir/config/bugsnag.php"

if [ -f "$BUGSNAGCONFIG" ]; then
    BUGSNAG=true
fi

# Get the new version number from the command line
#
NEW_VERSION="$1"

# Get & update the hash
#
CURRENT_GIT_HASH=$(git rev-parse --short HEAD)

# Get the current version number from the APPCONFIG file
#
CURRENT_VERSION=$(grep -E "\'APP_VERSION\'\,\s\'[0-9]+\.[0-9]+\.[0-9]+\'" "$APPCONFIG" | grep -E -o "([0-9]+\.[0-9]+\.[0-9]+)")
echo "Current version: $CURRENT_VERSION"

# Check to see if the version number is valid
#
CHECK=$(echo "$NEW_VERSION" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$")

# Do we have a new version number? If so, check to see if it's changed
#
if [ -n "$NEW_VERSION" ]; then

    # Do we have a valid version number? If not, let the user know
    #
    if [ -z "$CHECK" ]; then
        echo "Invalid version number: $NEW_VERSION"
    else
        echo "Bumping version to: $NEW_VERSION ($CURRENT_GIT_HASH)"

        # Update the version number
        #
        sed -i '' -E "s|\'APP_VERSION_HASH\'\,\ \'[a-z0-9]+\'|\'APP_VERSION_HASH\'\,\ \'$CURRENT_GIT_HASH\'|" "$APPCONFIG"
        sed -i '' -E "s|\'APP_VERSION\'\,\ \'[0-9]+\.[0-9]+\.[0-9]+\'|\'APP_VERSION\'\,\ \'$NEW_VERSION\'|" "$APPCONFIG"

        # Add changed config file(s)
        git add "$APPCONFIG"

        # Update & add Bugsnag config file(s)
        if [ "$BUGSNAG" = true ] ; then
            sed -i '' -E "s|\'BUGSNAG_APP_VERSION\'\,\ \'[0-9]+\.[0-9]+\.[0-9]+\'|\'BUGSNAG_APP_VERSION\'\,\ \'$NEW_VERSION\'|" "$BUGSNAGCONFIG"
            git add "$BUGSNAGCONFIG"
        fi

        git commit --amend --no-edit

        # Tag the current commit with the version number
        #
        git tag "$NEW_VERSION"
    fi
fi
