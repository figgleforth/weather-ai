#### Requirements
- OpenWeather API key stored in env var `OPENWEATHER_API_KEY` ([register here for an API key](https://home.openweathermap.org/users/sign_up))

#### Getting started
1. Run `$ bundle install`
2. Configure env vars
   1. See `.env.example` for environment variable configuration
3. Run `$ foreman start -f Procfile.dev`
4. Visit `localhost:3000`

#### Relevant code
- `app/helpers/forecast_helper` is used for the weather client instantiation, and weather lookups, using OpenWeather.
- `app/helpers/location_helper` is used for converting address into zipcode, using Geocoder.
- `app/models/forecast` is the weather data to be displayed after lookup.
  - There are no migrations to run, this is simply a wrapper holding only the relevant forecast details.
- 'test/helpers` and `test/models` are the relevant unit tests
