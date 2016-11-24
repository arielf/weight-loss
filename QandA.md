# Frequently asked Questions, Answers, & Comments

------------------

#### I'm not a coder, this is too difficult for me to use; can you help?

> I hear you. One reason I put this on github is so others can take it further: write a web or mail service on top, or even a smart-phone app.
>
> Since publishing I've become aware of one site using this work as a back-end. Please note this is very early, experimental, work in progress:
>
>    ***[weightbrains.com](http://weightbrains.com)***
>
> It would be cool to see more people taking this work further.
>


#### This is an example of how to not do scientific research!

> Indeed, this is not scientific research.   Rather, this is:
>
>   - Software that can help you make sense of your own data
>   - Sharing in hope of further work and improvement
>   - A personal story of discovery
>   - In the end (judging by results) - a success story
>


#### Isn't factor X missing (e.g. Coffee)?

> Yes, many additional factors are missing.  I encourage you to use your own data, and what you personally feel is most important.


#### Doesn't dehydration and depleting Glycogen in the liver explain most of this weight loss?

> For the 1st 24 hours of a diet, and about 1 Lb of loss (approx. weight of total body glycogen) yes.  However, I can't attribute over 20 Lb loss over 1 year to just water loss.

#### Doesn't caloric restriction explain all of this weight loss?

> This may be true.  I haven't counted calories and a more thorough experiment should add all the data it can use.
>
> However, I tried multiple times to restrict my diet and was not successful.  What led to success in my case is a combination of physiological and psychological factors. Most importantly, the realization that by trying a LCHF (Low Carb, High Fat) diet, I can sustain a diet regime (possibly calorie restricted, I don't know) that lead to a clear and sustainable weight loss.
>
> The story is about the discovery process of what worked for me in the end.

#### Machine learning: aren't you over-fitting the data?

> Possibly. The number of days in the data (about 120) may be too small, and my scales have low resolution. There may have other data-entry errors in it.
>
> OTOH: I tried many combinations, data-subsets, shufflings, bootstrapping, and while the details varied, the main conclusions were pretty consistent: longer sleep, Low carb, high fat, were leading me to losing weight.
>
> More data, and data from many people is always welcome.
>

#### Machine learning: how much data do I need?

> The more the better. More importantly: higher resolution scales (0.1 lb or less) are especially important.
>
> To increase the sample size, the most recent version of the software no longer uses each day as a single data point. It augments it in two ways:
>    - It applies a variable-length sliding window on 1..N consecutive days over the data to auto-generate additional data-points.
>    - It applies randomized bootstrapping on each data example. This adds another multiplier towards reducing random noise and variance.
>
> You're welcome to play with the Makefile `NDAYS` (max length of consecutive days of the sliding window) and `BS` (number of random bootstrapping rounds multiplier for each data-set example) parameters to see how much results change, and which part remains relatively stable.
> For example:
>       `make BS=7 NDAYS=5`
>
> My conclusions were that while some items in the middle fall into the "too little data to conclude from" category, items closer to the top/bottom, as a group, point to sleeping (fasting) longer and substituting carbs for fat, as likely weight-loss factors.

#### Can you tell the story of how it went viral, and how does it feel to go Viral?

>
> From my PoV, it was totally accidental.
>
> I was trying to lose weight, and since I'm into ML, I found it natural to us some machine learning to guide me, especially in the early stages. It helped.
>
> When I told this to a colleague of mine, she suggested I really have to share this more widely. So I dusted it up a it, cleaned the code to make it a bit more usable by others, wrote a few pages of background and put it on github.
>
> On github it sat for a few months with zero forks, zero stars, zero watchers, totally ignored by the world :-)
>
> Then some guy named Dmitri noticed it, and posted a link to Hacker News (news at Ycombinator.com)...
>
> The reaction was overwhelming.
>
> Some minutes later, I got an email from someone else I don't know, Victor, via github, saying "Congratulations, you've just made it to the top of HN..."
>
> It was a Friday evening. That's weekend I couldn't sleep. My mailbox was exploding too. It went viral over the interwebs. Hundreds of comments, thousands of stars on the github repository, many forks, people offering me jobs, invites to present at conferences, you name it.
>
>  There were some follow-ups on Reddit, Quora, and some other forums, and it quickly became the top unpaid link on google when searching for a few terms combining weight-loss and machine-learning.
>
> In moments like this, one wishes they had two copies of oneself. I have another life too.
>

