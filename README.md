# Discovering ketosis:<br>How to effectively (and easily)<br> lose weight



*Here is a chart of my weight vs time in the past 16 months or so:*

![weight vs time in the past 16 months or so](weight.2015.png  "weight loss progress")

The chart was generated from the data file `weight.2015.csv` by the script `date-weight.r` in this git repository.  It requires `R` and `ggplot2`.





























In the following I'll describe the thought process, other people ideas,  and the software I used to lead me in the right direction.

## Salient facts & initial observations

- I used to be a pretty thin person. Unfortunately, since moving to the US, I've been gaining weight.
- The US is a country where obesity is an epidemic.

[! First DMV photo and weight (with full clothing)](1992-ariel-dmv.png "143 pounds, sometimes in the 90's")


Does a US typical lifestyle has anything to do with this epidemic? After reading on the subject, I could point at a few of the main suspects:

 - Fast food is the default food
 - Most food we buy and eat is heavily processed -- [Food, Inc. (documentary)](http://www.takepart.com/foodinc/film)
 - "No Fat" and "Low Fat" labels are everywhere on supermarket shelves
 - Many foods are enriched and sweetened with corn-syrup -- [Sugar Coated (documentary)](http://sugarcoateddoc.com/)

As in many other instances, I realized I need to think for myself, ignore the "expert" advice, ideas like the FDA "food pyramid" and start listening to my own body, my own logic, and my data.

Once I did, the results followed.

## What didn't work

In the past, I tried several times to change my diet. After reading one of Atkins' books, I realized and accepted the fact that carbs are a major factor in gaining weight. But that realization alone, has not led to success.

My will power, apparently, was not enough. I had too much love of pizza, etc.  I would reduce my carb consumption and lose a few pounds (typically ~5 pounds) and then break-down go back to eating excess carbs, and gain all these pounds back, and then some.
My longest diet stretch lasted a few months.

It was obvious that something was missing in my method. I just had to find it. Obviously, I could increase my physical activity: say start training for a mini-marathon, but that's not what I felt comfortable with.

I realized early on that I need to adopt a lifesyle that not just reduces carbs, or add exercise, but is also sustainable and even enjoyable. Something that:

        - I could do for years
        - Never feel the urge to break habits
        - Is not hard, or unpleasant for me to do


## Early insights & eureka moments

Early in the process I started using machine learning to identify the factors that make me gain or lose weight. I used a simple method: every morning I would weight myself and record both the new weights and whatever I did in the past ~24 hours, not just the food I ate, but also whether I exercised, slept too little or too much etc.

The format of the data collection file was very simple, essentially a CSV with 3 columns, Date, Weight, and Yesterday Food/actions:
 
    #
    # vim: textwidth=0 nowrap
    # Diet data file: 2012-06 and on
    #
    # 'sleep' means at least 8 hours of sleep. Add weight for more hours.
    #
    Date,Weight,YesterdayFood
    2012-06-01,186.8,
    2012-06-12,184.8,
    2012-06-13,183.8,
    2012-06-14,183.6,coffeecandy:5 egg mayo oliveoil cheese:4 rice meat bread:0 peanut:5
    2012-06-15,183.4,meat sugarlesscandy salad cherry:4 bread:0 dietsnapple:2 egg mayo oliveoil
    2012-06-16,183.6,caprise bread grape:10 pasadena sugaryogurt dietsnapple:2 peanut:5 hotdog
    2012-06-17,182.6,grape:6 meat pistachio:5 peanut:5 cheese sorbet:5 orangejuice:2
    # and so on ...


I wrote a script to convert this file to vowpal-wabbit training-set regression format where the label is the change in weight (delta) in the past 24 hours, and the input features are what I've done or ate in the ~24 hours which led to this delta.

I was not dieting at that time. Just collecting data.

The machine learning process error convergence after roughly sorting
descending by delta (which reduces noise) looks like this:

![error convergence (after partial descending sort by delta)](vw-convergence.png  "loss convergence in 4 data passes")

You can reproduce my work by building your own data-file, installing vowpal-wabbit (and its utility `vw-varinfo`) and running `make` in this directory.

Here's how a typical result of running `make` looks like.

The positive relative-score values are life-style choices that make you gain weight, while the negative ones make you lose weight. Note that this data set is very noisy since it the number of examples is too small, my scales have a large error, and items that make you both lose and gain weight, often appear on the same line so they cancel each other and confuse the learning process. It is thus advised to focus mostly on the extremes (start and end) of the list.


    FeatureName       HashVal   ...   Weight RelScore
    nosleep            143407   ...  +0.6654 90.29%
    watermelon         149311   ...  +0.4636 62.91%
    sugarlemonade      203375   ...  +0.3975 53.94%
    trailmix           174671   ...  +0.3362 45.63%
    bread              135055   ...  +0.3345 45.40%
    caramelizedwalnut  148079   ...  +0.3316 44.99%
    bun                  1791   ...  +0.3094 41.98%

    ... (trimmed for brevity) ...

    stayhome           148879   ...  -0.2690 -36.50%
    bacon               64431   ...  -0.2998 -40.69%
    egg                197743   ...  -0.3221 -43.70%
    parmagian          121679   ...  -0.3385 -45.94%
    oliveoil           156831   ...  -0.3754 -50.95%
    halfnhalf          171855   ...  -0.4673 -63.41%
    sleep              127071   ...  -0.7369 -100.00%

Despite its noisy nature, insufficient data, and inaccuracies in weighting, the diet machine-learning experiment made 4 facts very obvious pretty early:

- Sleeping longer is #1 factor in losing weight.
- Lack of sleep does the opposite.
- Carbs make you gain weight. The worst are high-starch foods.
- Fatty and oily food does the opposite: it makes you lose weight

It took me a while to figure out the sleep part. When we sleep we don't eat. It is that simple.

Moreover: we tend to binge and snack while not particularly hungry, but we never do it during sleep.

Our sleeping time is our fasting time. The time we could potentially lose weight, provided that we channel our body chemistry to break-up excess stored-fat in these hours.


## Further progress

You may note that in the top chart there's a notable acceleration in the rate of weight loss.  The cause was deeper insights and better ability to sustain the diet the more I understood the causes of weight gain and loss.

Extending the fasting time was one major accelerator. I did that by:

- Skipping breakfast and
- Stop eating earlier in the evening before going to bed.

Loading up on fat in order to feel full was another accelerator of weight loss rate.

I now feel pretty confident that I can go all the way back to my original weight when I first landed in US soil.

At the present rate, it should take not more than 2 years to completely undo the damage of the past 20 years. 

It is important to stress that I also feel much better the more weight I lose. As a welcome side-effect, all the bordeline-high levels in my blood tests, have moved significantly towards normal averages during the same period when I lost weight.

Beware of doctors [who push statins](https://www.google.com/search?q=the+truth+about+statins) instead of suggesting a better diet. Doubt anyone who tells you you need to reduce fat. Run away if they tell you "high cholesterol" is dangerous.

My data has taught me that the body is an amazing machine. It is extremely adaptive. Cholesterol is an essential building block and your liver produces as much as it needs of it. It is not your ***high fat consumption***, it is the ***storage of fat process*** that makes you unhealthy.  An enzyme called Lipase breaks-up fat. To raise the levels of Lipase so your body fat gets converted to energy, you need to give the body fat as an alternative to carbohydrates. When the body has no blood sugar, and no glycogen left in the liver, it has no other choice but to adapt and compensate.  The source of energy (ATP synthesis) is switched from carbs to fats by producing more fat-breaking agents.

When Lipase (and all other enzymes in the fat-to-ATP chemical path) mobilize and their levels become constantly elevated in your body, you reach a new steady state (called ketosis) and that's when you start winning this fight.

Now, your night sleep fasting time becomes your best friend.  These fat-breaking agents keep working while you sleep, breaking up the stored fat, make you lose weight, and become healthier.


## Bottom-line: how to do it?

- The hardest part (especially at the beginning) is reduce carbs. The worst carbs are starches (pizza, pasta, bread etc.), then processed foods with high sugar content (sweet sodas, other juices, etc). You may afford carbs from time to time (say a pizza once a week). As it turns out, an occasional lapse isn't enough to get you out of ketosis. However, you need to make sure you consume ***much less carbs*** than in the past. Particularly, you must avoid binges of snacks like chips, pizza, doughnuts, and white bread.

- [Look-up Glycemic index on wikipedia](https://en.wikipedia.org/wiki/Glycemic_index). Avoid foods with high glycemic index. Have a sweet tooth? Eat an orange instead of drinking orange juice. The two have vastly different glycemic indexes and this makes a huge difference. If you must add sweetness to your cup of tea or coffee, use a splenda tablet (~0.1g) rather than a tea-spoon of sugar (several grams). Result: same sweetness effect, but much less glucose in the blood.

- High fat: I switched from milk to half-and-half.  Avocados, olive oil, mayo, coconut oil, etc.  Never worry about fat, you can eat as much as you want of it. This is what makes it much easier to avoid carbs because you can stuff yourself with fat and feel much less hungry and miss the carbs less. The beautiful thing is that the body is very good at figuring out "I have too much fat in the blood, so let's increase the amount of enzymes which break-up fat" and this makes you lose weight in the long run.  Most importantly never buy any product saying "low fat" or "fat free" on it, the food industry usually replaces the fat with sugar (so it tastes better, otherwise it tastes awful).

- A bit of exercise.  Of course more is better, but for some people this may be difficult. I don't excercise too much. I just bike to work and back about 20 min each way, meaning 40 min/day. Stuff like walking the dog (but walk faster), or Zumba dance to music, can work well too. The trick is to find something that you don't find hard to do. Then do a little bit of it every day.

- Longer fasting periods: Sleep longer if you can, stop eating as early as possible before going to sleep and start eating as late as possible after sleeping. I skip breakfast, and don't feel hungry in the morning anymore.  After long periods of fasting, the body chemistry adjusts: I need more ATP, but I don't have glucose in the blood, and the glycogen in the liver is all fully consumed (takes about 1-2 days of low or no carbs) so there's no other option but to start and break-up stored fat. This elevates the enzymes that help with breaking up fat and the Krebs cycle in the section where it matters, reverses direction.

- Eat eggs.  They are a wonderful combo of fat and protein with no carbs at all.  I read an interview with a japanese woman who reached 124 years and one of her secrets was to eat an egg daily.  My favorite food is a scrambled egg with grilled onions and olives.

- Eat slower, chew longer... don't swallow just yet! (humans, just like dogs, tend to swallow too soon). Then simply stop eating when you're full (from another recent interview with a 102 year-old man listing his secrets)

***

## Further reading:

- [The Krebs (aka Citric acid) cycle](https://en.wikipedia.org/wiki/Citric_acid_cycle)
- [Spikes of Insulin and their effects](https://en.wikipedia.org/wiki/Sugar_crash) - what the body does when it has excess of sugar vs excess of fat.
- [Glycemic Index](https://en.wikipedia.org/wiki/Glycemic_index)
- [Glycogen and its storage in the liver](https://en.wikipedia.org/wiki/Glycogen)


And watch this nice 7:41 minute video of James McCarter in Quantified Self (an eye opener for me):

- [James McCarter: The Effects of a Year in Ketosis](https://vimeo.com/147795263) 



