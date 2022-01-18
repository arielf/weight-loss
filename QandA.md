# Frequently asked Questions, Answers, & Comments

------------------

#### I'm not a coder, this is too difficult for me to use; can you help?

> I hear you. One reason I put this on github is so others can take it further: write a web or mail service on top, or even a smart-phone app.
>
> Since publishing I've become aware of one site using this work as a back-end. Please note this is very early, experimental, work in progress:
>
>    ***[weightbrains.com](http://weightbrains.com) alas, link is now dead***
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

> This may well be true.  I haven't counted calories and a more thorough experiment should add all the data it can use.
>
> However, I tried multiple times to restrict my diet and was not successful.  So even if "caloric restriction" is the best explanation, it comes short as "the solution".
>
> What led to success in my case is a combination of physiological and psychological factors. Most importantly, the realization that by trying a LCHF (Low Carb, High Fat) diet, I can sustain a diet regime (possibly calorie restricted, I don't know) that lead to a clear and sustainable weight loss.
>
> The story is about the discovery process of what worked for me in the end.

#### Machine learning: aren't you over-fitting the data?

> Possibly. The number of days in the data (about 120) may be too small, and my scales have low resolution. There may have other data-entry errors in it.
>
> OTOH: I tried many combinations, data-subsets, shuffling, bootstrapping, and while the details varied, the main conclusions were pretty consistent: longer sleep, Low carb, high fat, were leading me to losing weight.
>
> More data, and data from many people is always welcome.
>

#### Machine learning: how much data do I need?

> The more the better. More importantly: higher resolution scales (0.1 lb or less) are especially important.
>
> To increase the sample size, the most recent version of the software no longer uses each day as a single data point. It augments it in two ways:
>   - It applies a variable-length sliding window on 1..N consecutive days over the data to auto-generate additional data-points.
>   - It applies randomized bootstrapping on each data example. This adds another multiplier towards reducing random noise and variance.
>
> You're welcome to play with the Makefile `NDAYS` (max length of consecutive days of the sliding window) and `BS` (number of random bootstrapping rounds multiplier for each data-set example) parameters to see how much results change, and which part remains relatively stable.
> For example:
>
>      make BS=7 NDAYS=5
>
> My conclusions were that while some items in the middle fall into the "too little data to conclude from" category, items closer to the top/bottom, as a group, point to sleeping (fasting) longer and substituting carbs for fat, as likely weight-loss factors.

#### What's the story on statins? How is this related to weight-loss?

> [Original appeared in the HackerNews thread, some edits applied]
>
> Here's my personal experience with statins. I may be wrong, but I'm following my compass while always open to be proven otherwise.
>
> Doctor: "Your 'bad cholesterol' is borderline, I want you to start taking "Lipitor"...

> Observation: when the 'Lipitor' patent expired, and it became a cheap generic drug, the suggestion turned into 'Crestor' which I learned has a bit longer effective half-life, and way higher price.

> ***Me: (while adopting a different diet)***
> *"Hmm statins would have taken my cholesterol and triglicerids  _maybe_ 3% lower and here I am 20% lower after a year of a simple, self-studied, diet change. Maybe there are better ways to lower the so called 'bad cholesterol'?*

> Further study: there's always a new statin the moment the previous patent expires.
>
> Check out the following names on Wikipedia:
>
>    - Compactin
>    - Simvastatin
>    - Fluvastatin
>    - Cerivastatin
>    - Atorvastatin
>    - Rosuvastatin
>
> These are all chemical names, not brand names, the last two on the list are the brands: known as "Lipitor" and "Crestor".
>
> So I don't know. I'm 100% sure all my doctors are well meaning and caring and I have nothing against them, but my confidence in such health suggestions, in research funded by big-pharma, and in the new great statin de-jour while America keeps getting obese and less healthy, is, how can I put it? A bit shaken.
>
> Again, just prove me wrong, and I'll change my view.


#### Can you tell the story of how, and how does it feel to "Go Viral"?

>
> From my PoV, it was totally accidental.
>
> I was trying to lose weight, and since I'm into ML, I found it natural to try some machine learning to guide me, especially in the early stages. It helped.
>
> When I told this to a colleague of mine, she suggested "You heave to share this more widely!" So I dusted it up a bit, cleaned the code to make it a bit more usable by others, wrote a few pages of background and put it on github.
>
> On github it sat for a few months with zero forks, zero stars, zero watchers, totally ignored by the world :-)
>
> Then some guy named Dmitri noticed it, and posted a link to [Hacker News](http://ycombinator.com/news)
>
> The reaction was overwhelming.
>
> Some minutes later, I got an email from someone else I don't know, Victor, via github, saying "Congratulations, you've just made it to the top of HN..."
>
> It was a Friday evening. That's weekend I couldn't sleep. My mailbox was exploding too. It went viral over the "interwebs". Hundreds of comments, thousands of stars on the github repository, many forks, people offering me jobs, invites to present at conferences, you name it.
>
>  There were some follow-ups on Reddit, Quora, and some other forums, and it quickly became the top unpaid link on google when searching for a few terms combining weight-loss and machine-learning.
>
> In moments like this, one wishes they had two copies of oneself. I have another life too.
>
