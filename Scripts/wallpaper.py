#!/usr/bin/env python
import os
import random
import click
import praw
import requests
from PIL import Image


MIN_WIDTH = 1920
MIN_HEIGHT = 1200
MAX_RETRIES = 10

SUBS = [
    'wallpapers',
    'wallpaper',
    'earthporn',
    'skylineporn',
    'bigwallpapers',
    'nocontext_wallpapers',
    #'NSFW_Wallpapers',
]

@click.command()
@click.option('subreddit', '-s', default=None)
def main(subreddit):
    if subreddit is None:
        subreddit = random.choice(SUBS)

    reddit = praw.Reddit(
        user_agent='wallpaperbot/v0',
        client_secret=None,
        client_id=os.getenv('CLIENT_ID')
    )
    click.echo('Getting wallpaper from {}'.format(subreddit))
    image, submission = None, None
    for submission in reddit.subreddit(subreddit).hot(limit=MAX_RETRIES):
        response = requests.get(submission.url, stream=True)
        response.raw.decode_content = True
        if response.status_code == 200:
            mime, type = response.headers['Content-Type'].split('/')
            if mime == 'image':
                image = Image.open(response.raw)
                if image.width >= MIN_WIDTH and image.height >= MIN_HEIGHT:
                    break
    if image is not None:
        # save image to disk
        image.save(os.path.expanduser('~/.background.png'), 'PNG')
        click.echo('New background saved!')
    else:
        click.echo('No suitable background found!')

if __name__ == '__main__':
    main()

