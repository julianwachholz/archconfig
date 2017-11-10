#!/usr/bin/env python
import os
import random
import click
import praw
import requests
from PIL import Image


MIN_WIDTH = 1920
MIN_HEIGHT = 1200
MAX_RETRIES = 25

SUBS = [
    'wallpapers',
    'wallpaper',
    'earthporn',
    'skylineporn',
    'bigwallpapers',
    # 'nocontext_wallpapers',
    # 'gmbwallpapers',
    # 'NSFW_Wallpapers',
]

methods = [
    # 'controversial',
    # 'gilded',
    'hot',
    'new',
    'rising',
    # 'top:all',
    'top:day',
    'top:hour',
    # 'top:week',
    # 'top:month',
    # 'top:year',
]

@click.command()
@click.option('--subreddit', '-s' 'subreddit', default=None)
@click.option('--type', '-t', 'method', default=None)
@click.option('--nsfw', 'include_nsfw', is_flag=True, default=False)
def main(subreddit, method, include_nsfw=False, retry=0):
    if subreddit is None:
        subreddit = random.choice(SUBS)
    if method is None:
        method = random.choice(methods)

    reddit = praw.Reddit(
        user_agent='wallpaperbot/v0',
        client_secret=None,
        client_id=os.getenv('CLIENT_ID')
    )
    image, submission = None, None
    sub = reddit.subreddit(subreddit)
    kwargs = {
        'limit': MAX_RETRIES,
    }

    if method == 'top':
        kwargs['time_filter'] = 'all'
    elif method.startswith('top:'):
        method, kwargs['time_filter'] = method.split(':')

    good_images = []
    click.echo('Getting wallpaper from {}/{}{}'.format(subreddit, method, kwargs.get('time_filter', '')))
    for submission in getattr(sub, method)(**kwargs):
        click.echo('Checking {!r}'.format(submission.title))
        if submission.over_18 and not include_nsfw:
            click.echo('Submission is [nsfw], skipping')
            continue
        if submission.url.split('.')[-1] not in ['png', 'jpg', 'jpeg']:
            click.echo('Submission is not an image, skipping')
            continue
        response = requests.get(submission.url, stream=True)
        response.raw.decode_content = True
        if response.status_code == 200:
            mime, type = response.headers['Content-Type'].split('/')
            if mime == 'image':
                image = Image.open(response.raw)
                click.echo('Found {}x{} image.'.format(image.width, image.height))
                if all([
                    image.width >= MIN_WIDTH,
                    image.height >= MIN_HEIGHT,
                    image.width > image.height,
                ]):
                    good_images.append(image)
    if len(good_images) > 0:
        image = random.choice(good_images)
        # save image to disk
        image.save(os.path.expanduser('~/.background.original.png'), 'PNG')
        image.save(os.path.expanduser('~/.background.png'), 'PNG')
        click.echo('New background saved!')
    else:
        click.echo('No suitable background found!')

if __name__ == '__main__':
    main()

