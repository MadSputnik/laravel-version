## About

Laravel-Version is a small Bash utility to easily add a [Semver](https://semver.org/) version tag and update the configuration file(s) within your Laravel application.

## Usage

1. Copy the file `version.sh` to your Laravel project root
2. Open `version.sh` in a text editor and set `RELEASE_BRANCH="main"` to your release branch. Save and close the file.
3. Make it executable: `chmod +x version.sh`
4. Create a `config/_app.php` configuration file (see [`_app.php.example`](_app.php.example))
5. If you have Bugsnag installed, ensure that
<ol type="a">
	<li>You published the Bugsnag config file (`php artisan vendor:publish`)</li>
	<li>`APP_VERSION` in `config/bugsnag.php` has a default value, i.e. `env('BUGSNAG_APP_VERSION', '0.0.1')`</li>
</ol>
6. Make some changes to your project
7. Ensure you are on your release branch
8. Run `./version.sh 1.0.0` to update the config files. This will amend the last commit with the updated config files and tag the project with version `1.0.0`.
9. Run `./version.sh` to see the current version

#### Get the current version in Laravel

Once you have tagged a version, you can grab the values via config helper:

```
config('_app.version'); // 1.0.0
config('_app.version_hash'); // 02c8c78
```

## Contributing

Pull requests are the best way to propose changes to the codebase. I actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. Make your changes.
3. Issue that pull request!

#### Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same MIT License that covers the project. Feel free to contact the maintainer if that's a concern.

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
