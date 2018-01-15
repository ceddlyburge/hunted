# Hunted

Live:
http://cuddlyburger.hunted.s3-website.eu-west-2.amazonaws.com/

Hunted is a simple game written to develop my skills.

It is written in Elm 0.18.

Forked from James Porters version of the same thing, whilst pairing at a meetup


## Serve locally:

```
npm start
```

* Open [http://localhost:8080/](http://localhost:8080/)
* The main Elm file is `src/elm/Game.elm`
* Will auto reload on changes


## Build & bundle for prod:

```
npm run build
```

* Files are saved into the `/dist` folder; will require web server due to paths (can't just open in browser)

## Deploy 

### Setup an S3 bucket for the site

Create an AWS account and an S3 bucket.

https://s3.console.aws.amazon.com/s3

Enable the bucket for static web site hosting.

https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html

### Setup AWS command line

Install aws command line interface

https://aws.amazon.com/cli/


Setup the aws command line tools
`aws configure` on command line and type in the `AWS Access Key ID`, `AWS Secret Access Key` and `Default region name`. You can leave `Default output format` blank. 
There is an annoying mapping between region code and region name, which you can look up here. Make sure they match. http://docs.aws.amazon.com/general/latest/gr/rande.html

### Use AWS command line to publish

`aws s3 cp dist s3://cuddlyburger-hunted --recursive` on command line (replace `cuddlyburger-hunted` with your s3 bucket name).

This command should be run in the root of the repo, and will synchronise the dist folder (which you must build first withh 'npm run build' as described above) with the s3 bucket.	