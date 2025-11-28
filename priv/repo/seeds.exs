# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Talents.Repo.insert!(%Talents.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Talents.Repo
alias Talents.Themes.Theme
alias Talents.Themes

themes = %{
  1 => %{
    name: "Achiever",
    domain: "E",
    description:
      "People exceptionally talented in the Achiever theme work hard and possess a great deal of stamina. They take immense satisfaction in being busy and productive.",
    i_am: "a hard worker",
    i_will: "set the pace for production",
    i_love: "completing tasks",
    i_dislike: "a lack of diligence",
    i_bring: "intensity and stamina of effort",
    i_need: "freedom to work at my own pace",
    metaphor_image: "Completing a race, getting to the finish line",
    barrier_label: "work is more important than people",
    text_contrast_one: "Achiever: I want to get it done. / Activator: I want to get it started. ",
    text_contrast_two: "Achiever: Intense diligence. / Intellection: Intense thinking."
  },
  2 => %{
    name: "Activator",
    domain: "I",
    description:
      "People exceptionally talented in the Activator theme can make things happen by turning thoughts into action. They want to do things now, rather than simply talk about them.",
    i_am: "impatient with inactivity",
    i_will: "create momentum",
    i_love: "initiation, instigation",
    i_dislike: "waiting, wasting time",
    i_bring: "a catalytic sense of urgency",
    i_need: "less discussion, more action",
    metaphor_image: "Getting out of the blocks quickly",
    barrier_label: "leaps before looking",
    text_contrast_one:
      "Activator: There is no substitute for action. / Intellection: There is no substitute for thinking. ",
    text_contrast_two:
      "Activator: Do it until you get it right. / Deliberative: Do it when you get it right."
  },
  3 => %{
    name: "Adaptability",
    domain: "R",
    description:
      "People exceptionally talented in the Adaptability theme prefer to go with the flow. They tend to be “now” people who take things as they come and discover the future one day at a time.",
    i_am: "a here-and-now person",
    i_will: "react with immediacy to the immediate",
    i_love: "spontaneity",
    i_dislike: "predictability",
    i_bring: "a willingness to follow the lead of change",
    i_need: "present pressures that demand an immediate response",
    metaphor_image: "Like a river, go with the flow",
    barrier_label: "directionless",
    text_contrast_one:
      "Adaptability: I like it when every day is different. / Discipline: I like it when every day is the same. ",
    text_contrast_two:
      "Adaptability: Responds to changes in an environment. / Arranger: Initiates or manages changes in an environment."
  },
  4 => %{
    name: "Analytical",
    domain: "T",
    description:
      "People exceptionally talented in the Analytical theme search for reasons and causes. They have the ability to think about all of the factors that might affect a situation.",
    i_am: "logical and objective in approach",
    i_will: "find simplicity in the midst of complexity",
    i_love: "data and facts",
    i_dislike: "things that are not or cannot be proven",
    i_bring: "dispassionate thinking to emotional issues",
    i_need: "time to think",
    metaphor_image: "A reduction — boiling down to essence",
    barrier_label: "paralysis by analysis",
    text_contrast_one: "Analytical: My head guides me. / Empathy: My heart guides me. ",
    text_contrast_two:
      "Analytical: Truth is objective and must be measured. / Connectedness: Truth is spiritual and may be invisible."
  },
  5 => %{
    name: "Arranger",
    domain: "E",
    description:
      "People exceptionally talented in the Arranger theme can organize, but they also have a flexibility that complements this ability. They like to determine how all of the pieces and resources can be arranged for maximum productivity.",
    i_am: "comfortable with lots of moving parts",
    i_will: "work effectively and efficiently through others",
    i_love: "initiating and managing necessary change",
    i_dislike: "resistance to necessary change",
    i_bring: "flexibility and interactivity",
    i_need: "a dynamic environment",
    metaphor_image: "A maestro, a coordinator",
    barrier_label: "difficult to follow because of frequent rearrangements",
    text_contrast_one: "Arranger: Multiplicity. / Focus: Singularity. ",
    text_contrast_two:
      "Arranger: A juggler who momentarily touches all the balls. / Responsibility: A football player who tenaciously holds on to the ball."
  },
  6 => %{
    name: "Belief",
    domain: "E",
    description:
      "People exceptionally talented in the Belief theme have certain core values that are unchanging. Out of these values emerges a defined purpose for their lives.",
    i_am: "passionate, uncompromising about core values",
    i_will: "make sacrifices for things that are important",
    i_love: "altruism",
    i_dislike: "anything that does not mesh or align with my beliefs",
    i_bring: "stability, clarity, conviction",
    i_need: "a cause or purpose for which to live",
    metaphor_image: "Missionary for some idea",
    barrier_label: "set in ways",
    text_contrast_one:
      "Belief: There is only one right way, so I will not be distracted by other paths. / Strategic: There are many possible ways, so I must consider them all. ",
    text_contrast_two:
      "Belief: Seeing comes with believing. / Analytical: Believing comes with seeing."
  },
  7 => %{
    name: "Command",
    domain: "I",
    description:
      "People exceptionally talented in the Command theme have presence. They can take control of a situation and make decisions.",
    i_am: "direct and decisive",
    i_will: "push back when pushed",
    i_love: "exerting control in situations that seem out of control",
    i_dislike: "passivity and avoidance",
    i_bring: "emotional clarity",
    i_need: "challenges and conflicts",
    metaphor_image: "Comfortable in the driver’s seat",
    barrier_label: "bossy, dictator",
    text_contrast_one:
      "Command: Creates clarity through polarization. / Harmony: Creates consensus through harmonization. ",
    text_contrast_two:
      "Command: People are drawn to you because they know what you think. / Empathy: People are drawn to you because they know what they feel."
  },
  8 => %{
    name: "Communication",
    domain: "I",
    description:
      "People exceptionally talented in the Communication theme generally find it easy to put their thoughts into words. They are good conversationalists and presenters.",
    i_am: "verbally expressive",
    i_will: "connect with others through words",
    i_love: "stories and storytellers",
    i_dislike: "experience without expression",
    i_bring: "attention to messages that must be heard",
    i_need: "a sounding board, an audience",
    metaphor_image: "Silence is not golden",
    barrier_label: "blabbermouth",
    text_contrast_one:
      "Communication: I think and learn best when I can talk with others. / Intellection: I think and learn best when I can be alone and quiet. ",
    text_contrast_two:
      "Communication: Telling a story helps others understand my message. / Context: The re-telling of history helps others remember the past."
  },
  9 => %{
    name: "Competition",
    domain: "I",
    description:
      "People exceptionally talented in the Competition theme measure their progress against the performance of others. They strive to win first place and revel in contests.",
    i_am: "aware of my competitors",
    i_will: "strive to win",
    i_love: "a chance to go against the best",
    i_dislike: "coming in second",
    i_bring: "an aspiration to be the best",
    i_need: "peers for comparison and motivation",
    metaphor_image: "No consolation prizes — the gold medal is the only medal",
    barrier_label: "sore loser",
    text_contrast_one:
      "Competition: When I watch others perform, I get better. / Significance: When others watch me perform, I get better. ",
    text_contrast_two:
      "Competition: The scoreboard measures my progress and validates victory. / Analytical: Data quantify experience and validate theories."
  },
  10 => %{
    name: "Connectedness",
    domain: "R",
    description:
      "People exceptionally talented in the Connectedness theme have faith in the links among all things. They believe there are few coincidences and that almost every event has meaning.",
    i_am: "incredibly aware of the borderless and timeless human family",
    i_will: "integrate parts into wholes",
    i_love: "circles of life and threads of continuity",
    i_dislike: "an “us vs. them” mentality",
    i_bring: "an appreciation of the mystery and wonder of life and all creation",
    i_need:
      "to be part of something bigger than myself: a family, a team, an organization, a global community",
    metaphor_image: "Person as body, mind and spirit",
    barrier_label: "flaky, new-ager, not in touch with reality",
    text_contrast_one: "Connectedness: Accepts mystery. / Analytical: Proves truth. ",
    text_contrast_two:
      "Connectedness: Aware of the inherent, invisible unity that already exists. / Includer: Aware of the invisible social exclusion that often exists."
  },
  11 => %{
    name: "Consistency",
    domain: "E",
    description:
      "People exceptionally talented in the Consistency theme are keenly aware of the need to treat people the same. They crave stable routines and clear rules and procedures that everyone can follow.",
    i_am: "more interested in group needs than individual wants",
    i_will: "reduce variance and increase uniformity",
    i_love: "repeating things in the exact same way",
    i_dislike: "unnecessary customization",
    i_bring: "rules and policies that promote cultural predictability",
    i_need: "standard operating procedures",
    metaphor_image: "The beauty and efficiency of a consistent golf swing",
    barrier_label: "rules trump relationships and results",
    text_contrast_one:
      "Consistency: Treating people similarly promotes fairness. / Individualization: Treating people differently promotes fairness. ",
    text_contrast_two:
      "Consistency: I like merry-go-rounds. / Adaptability: I like roller coasters."
  },
  12 => %{
    name: "Context",
    domain: "T",
    description:
      "People exceptionally talented in the Context theme enjoy thinking about the past. They understand the present by researching its history.",
    i_am: "appreciative of my predecessors and prior events",
    i_will: "remember important history",
    i_love: "the retrospective",
    i_dislike: "when the past is forgotten",
    i_bring: "accurate memories and valuable memorabilia",
    i_need: "relevant background for discussions and decisions",
    metaphor_image: "Rearview mirror — essential for safe driving",
    barrier_label: "stuck in the past",
    text_contrast_one:
      "Context: I naturally remember and revere what has been. / Futuristic: I naturally anticipate and imagine what could or should be. ",
    text_contrast_two:
      "Context: I can proceed when I understand the history. / Focus: I can proceed when the goal is clear."
  },
  13 => %{
    name: "Deliberative",
    domain: "E",
    description:
      "People exceptionally talented in the Deliberative theme are best described by the serious care they take in making decisions or choices. They anticipate obstacles.",
    i_am: "a vigilant observer of potential risk",
    i_will: "anticipate things that could go wrong",
    i_love: "restraint and caution in the face of risk",
    i_dislike: "a rush to judgment",
    i_bring: "a thorough and conscientious approach",
    i_need: "time to listen and think before being expected to speak",
    metaphor_image:
      "An ounce of prevention is worth a pound of cure; a jury must deliberate before there is a verdict",
    barrier_label: "hesitant — it’s the early bird that gets the worm",
    text_contrast_one:
      "Deliberative: Like a brake, I tend to slow things down. / Activator: Like an accelerator, I tend to speed things up. ",
    text_contrast_two: "Deliberative: Socially cautious. / Woo: Socially adventurous."
  },
  14 => %{
    name: "Developer",
    domain: "R",
    description:
      "People exceptionally talented in the Developer theme recognize and cultivate the potential in others. They spot the signs of each small improvement and derive satisfaction from evidence of progress.",
    i_am: "patient with the inexperienced and unseasoned",
    i_will: "get satisfaction from the growth of others",
    i_love: "human potential and progress",
    i_dislike: "wasted or unrealized potential",
    i_bring: "a commitment — time and energy — to human growth",
    i_need: "someone to invest in",
    metaphor_image: "A parent’s patience with a baby learning to walk",
    barrier_label: "wastes time on low performers",
    text_contrast_one:
      "Developer: I notice and promote growth in others. / Maximizer: I notice and promote excellence. ",
    text_contrast_two:
      "Developer: Interested in getting people done. / Achiever: Interested in getting work done."
  },
  15 => %{
    name: "Discipline",
    domain: "E",
    description:
      "People exceptionally talented in the Discipline theme enjoy routine and structure. Their world is best described by the order they create.",
    i_am: "an efficient manager of limited resources",
    i_will: "plan in advance and then follow the plan",
    i_love: "things that are organized and orderly",
    i_dislike: "chaos and confusion and flying by the seat of one’s pants",
    i_bring: "precision and detail orientation",
    i_need: "a structured and organized environment",
    metaphor_image: "Having one’s ducks in a row",
    barrier_label: "may be resistant to change",
    text_contrast_one:
      "Discipline: I meet deadlines because it makes me feel good. / Responsibility: I meet deadlines because it makes others respect me. ",
    text_contrast_two:
      "Discipline: Can’t see the forest for the trees. / Connectedness: Can’t see the trees for the forest."
  },
  16 => %{
    name: "Empathy",
    domain: "R",
    description:
      "People exceptionally talented in the Empathy theme can sense other people’s feelings by imagining themselves in others’ lives or situations.",
    i_am: "an emotional person",
    i_will: "make the visceral explicit",
    i_love: "the gladness, sadness, madness of humanity",
    i_dislike: "those things that block or limit emotional expression",
    i_bring: "emotional intelligence",
    i_need: "freedom to laugh, cry, vent",
    metaphor_image: "People’s affect will often determine their effect",
    barrier_label: "bleeding heart",
    text_contrast_one:
      "Empathy: I usually can tell how someone feels. / Individualization: I usually can tell who someone is. ",
    text_contrast_two:
      "Empathy: Intuition helps me decide what to do. / Analytical: Data help me decide what to do."
  },
  17 => %{
    name: "Focus",
    domain: "E",
    description:
      "People exceptionally talented in the Focus theme can take a direction, follow through and make the corrections necessary to stay on track. They prioritize, then act.",
    i_am: "intensely and intentionally single-minded",
    i_will: "persevere until the goal is reached",
    i_love: "to begin with the end in mind",
    i_dislike: "going off on misdirected tangents",
    i_bring: "clarity through concentration and direction",
    i_need: "a goal to establish priorities",
    metaphor_image: "“In the zone”",
    barrier_label: "destination mentality may limit enjoyment of the journey",
    text_contrast_one: "Focus: I have a goal. / Futuristic: I have a dream. ",
    text_contrast_two:
      "Focus: I have a goal I plan to reach. / Discipline: I have a plan to reach my goal."
  },
  18 => %{
    name: "Futuristic",
    domain: "T",
    description:
      "People exceptionally talented in the Futuristic theme are inspired by the future and what could be. They energize others with their visions of the future.",
    i_am: "fascinated with tomorrow",
    i_will: "anticipate and imagine what could or should be",
    i_love: "the inspiration that comes from dreaming",
    i_dislike: "contentment with the status quo",
    i_bring: "previews, predictions, forecasts",
    i_need: "opportunities to talk about the foreseen future",
    metaphor_image: "Visionary",
    barrier_label: "head in the clouds",
    text_contrast_one:
      "Futuristic: I’m so preoccupied with tomorrow that I’m not ready for today. / Adaptability: I’m so occupied with today that I’m not ready for tomorrow. ",
    text_contrast_two:
      "Futuristic: I can see a better world. / Strategic: I can see the route that will take us to a better world."
  },
  19 => %{
    name: "Harmony",
    domain: "R",
    description:
      "People exceptionally talented in the Harmony theme look for consensus. They don’t enjoy conflict; rather, they seek areas of agreement.",
    i_am: "calm, even-keeled",
    i_will: "seek to eliminate the waste of emotional energy",
    i_love: "the sacrifice of personal agendas to facilitate group performance",
    i_dislike: "negative effects of friction",
    i_bring: "a peace-loving, conflict-resistant approach",
    i_need: "areas of agreement, common ground",
    metaphor_image: "Smoothing ruffled feathers",
    barrier_label: "afraid of conflict",
    text_contrast_one:
      "Harmony: Let’s do what works best. / Belief: I want to do what matters most. ",
    text_contrast_two:
      "Harmony: Being interdependent, I willingly defer to experts. / Self-Assurance: Being independent, I confidently rely on my own expertise."
  },
  20 => %{
    name: "Ideation",
    domain: "T",
    description:
      "People exceptionally talented in the Ideation theme are fascinated by ideas. They are able to find connections between seemingly disparate phenomena.",
    i_am: "unaffected by the ambiguity and risk of innovation",
    i_will: "think outside the box",
    i_love: "coming up with something brand new",
    i_dislike: "doing what we have always done",
    i_bring: "new and fresh perspectives",
    i_need: "freedom to explore possibilities without restraints or limits",
    metaphor_image: "Creativity of an artist, blank canvas or page, lump of clay",
    barrier_label: "impractical",
    text_contrast_one:
      "Ideation: I open the windows of my mind to increase the possibility of discovery. / Focus: I close the windows of my mind to decrease the possibility of distraction. ",
    text_contrast_two:
      "Ideation: A blue-sky approach to the creation of innovation is the best way to get a competitive advantage. / Harmony: The down-to-earth approach of efficient collaboration is the best way to get a competitive advantage."
  },
  21 => %{
    name: "Includer",
    domain: "R",
    description:
      "People exceptionally talented in the Includer theme accept others. They show awareness of those who feel left out and make an effort to include them.",
    i_am: "aware of exclusion and understand its repercussions",
    i_will: "shrink the gap between the haves and have-nots",
    i_love: "assimilation and integration",
    i_dislike: "cliques",
    i_bring: "a high level of tolerance with an acceptance of diversity",
    i_need: "room for everyone",
    metaphor_image: "Cliques are breeding grounds for clichéd thinking",
    barrier_label: "indiscriminate",
    text_contrast_one:
      "Includer: I work for the acceptance of those on the outside. / Harmony: I work for the agreement of those on the inside. ",
    text_contrast_two:
      "Includer: Be indiscriminately accepting of all who are on the bus. / Maximizer: Be discriminatingly selective about who gets on the bus."
  },
  22 => %{
    name: "Individualization",
    domain: "R",
    description:
      "People exceptionally talented in the Individualization theme are intrigued with the unique qualities of each person. They have a gift for figuring out how different people can work together productively.",
    i_am: "a customizer",
    i_will: "see the potential in human diversity rather than its problem",
    i_love: "people getting to do what they do best",
    i_dislike: "a one-size-fits-all approach",
    i_bring: "an understanding of people that is valuable for placement",
    i_need: "individual expectations that are created to fit a person",
    metaphor_image: "Casting director — uses intelligence about people",
    barrier_label: "sacrifices group need for individual needs",
    text_contrast_one:
      "Individualization: I know who you are. / Relator: I want to know you, and I want you to know me. ",
    text_contrast_two:
      "Individualization: Starts with a person and finds the right job for him. / Arranger: Starts with a job that needs to get done and finds the right person for it."
  },
  23 => %{
    name: "Input",
    domain: "T",
    description:
      "People exceptionally talented in the Input theme have a need to collect and archive. They may accumulate information, ideas, artifacts or even relationships.",
    i_am: "utilitarian resource collector",
    i_will: "hang on to things that could be helpful resources for others",
    i_love: "to provide relevant and tangible help",
    i_dislike: "not having things that would be useful to others",
    i_bring: "tangible tools that can facilitate growth and performance",
    i_need: "space to store the resources I naturally acquire",
    metaphor_image: "Sponge — absorbent (input) dispenser (output)",
    barrier_label: "packrat with too much lying around",
    text_contrast_one:
      "Input: I love to collect things that are potentially helpful. / Learner: I love the process of learning. ",
    text_contrast_two:
      "Input: I help people by sharing tangible tools I have acquired. / Ideation: I help people by sharing creative ideas I have conceived."
  },
  24 => %{
    name: "Intellection",
    domain: "T",
    description:
      "People exceptionally talented in the Intellection theme are characterized by their intellectual activity. They are introspective and appreciate intellectual discussions.",
    i_am: "conceptual, deep, solitary",
    i_will: "see thinking as synonymous with doing",
    i_love: "the theoretical because it is the precursor to the practical",
    i_dislike: "a thoughtless approach to anything",
    i_bring: "depth of understanding and wisdom",
    i_need: "time for reflection and meditation",
    metaphor_image: "Drilling deep, plumbing the depths",
    barrier_label: "isolated and aloof",
    text_contrast_one:
      "Intellection: An inquiring approach to growth and learning. / Input: An acquiring approach to growth and learning. ",
    text_contrast_two:
      "Intellection: Thinks about concepts that need to be understood. / Restorative: Thinks about problems that need to be solved."
  },
  25 => %{
    name: "Learner",
    domain: "T",
    description:
      "People exceptionally talented in the Learner theme have a great desire to learn and want to continuously improve. The process of learning, rather than the outcome, excites them.",
    i_am: "one who enjoys the experience of being a learner",
    i_will: "follow the things that interest me",
    i_love: "to live on the frontier/the cutting edge",
    i_dislike: "knowing it all and know-it-alls",
    i_bring: "a learning perspective",
    i_need: "exposure to new information and experiences",
    metaphor_image: "Yes to learning curves, no to learning plateaus",
    barrier_label: "curiosity may lead to irrelevance or non-productivity",
    text_contrast_one:
      "Learner: My interests guide my intentions. / Focus: My intentions guide my interests. ",
    text_contrast_two:
      "Learner: I am always interested in learning something new. / Woo: I am always interested in meeting someone new."
  },
  26 => %{
    name: "Maximizer",
    domain: "I",
    description:
      "People exceptionally talented in the Maximizer theme focus on strengths as a way to stimulate personal and group excellence. They seek to transform something strong into something superb.",
    i_am: "committed to excellence",
    i_will: "focus on what is strong and manage what is weak",
    i_love: "a maximum return on investments",
    i_dislike: "an obsession with weakness fixing",
    i_bring: "a quality orientation",
    i_need: "quality to be valued as much as quantity",
    metaphor_image: "Good to great and good, better, best",
    barrier_label: "picky, never satisfied",
    text_contrast_one:
      "Maximizer: I aspire to meet or exceed a standard of excellence. / Competition: I aspire to be number one. ",
    text_contrast_two:
      "Maximizer: I want to build something great. / Restorative: I want to fix something broken."
  },
  27 => %{
    name: "Positivity",
    domain: "R",
    description:
      "People exceptionally talented in the Positivity theme have contagious enthusiasm. They are upbeat and can get others excited about what they are going to do.",
    i_am: "optimistic, hopeful, fun-loving",
    i_will: "lift and lighten emotional environments",
    i_love: "living life to its fullest",
    i_dislike: "negative people who drain the life out of others",
    i_bring: "contagious energy and enthusiasm",
    i_need: "freedom to experience the joy and drama of life",
    metaphor_image: "Glass is half full, not half empty",
    barrier_label: "naive",
    text_contrast_one: "Positivity: Light-hearted. / Analytical: Serious-minded. ",
    text_contrast_two:
      "Positivity: Praise can’t be overdone, so I am generous with it. / Deliberative: Praise can be overdone, so I use it sparingly."
  },
  28 => %{
    name: "Relator",
    domain: "R",
    description:
      "People exceptionally talented in the Relator theme enjoy close relationships with others. They find deep satisfaction in working hard with friends to achieve a goal.",
    i_am: "genuine and authentic",
    i_will: "get to know more about the people closest to me",
    i_love: "close, caring, mutual relationships",
    i_dislike: "the initial social discomfort of meeting someone new",
    i_bring: "social depth and transparency",
    i_need: "time and opportunities for one-on-one interactions",
    metaphor_image: "Knowing and being known by friends",
    barrier_label: "cliquish cronyism",
    text_contrast_one:
      "Relator: Socially transparent, I invite my friends in. / Includer: Socially inclusive, I invite outsiders in. ",
    text_contrast_two:
      "Relator: I want to get to know more about the people I already know. / Woo: I want to get to know more people."
  },
  29 => %{
    name: "Responsibility",
    domain: "E",
    description:
      "People exceptionally talented in the Responsibility theme take psychological ownership of what they say they will do. They are committed to stable values such as honesty and loyalty.",
    i_am: "someone others often trust to get things done",
    i_will: "keep promises and follow through on commitments",
    i_love: "the respect of others",
    i_dislike: "disappointing others and being disappointed by others",
    i_bring: "dependability and loyalty",
    i_need: "freedom to take ownership",
    metaphor_image: "Serious owner — not disinterested renter",
    barrier_label: "can’t say no or let go",
    text_contrast_one:
      "Responsibility: If you can’t do it right, don’t do it. / Activator: Doing something is always better than not doing anything. ",
    text_contrast_two:
      "Responsibility: I feel intense guilt when I fail to do something right. / Significance: I feel intense regret when I miss an opportunity to succeed."
  },
  30 => %{
    name: "Restorative",
    domain: "E",
    description:
      "People exceptionally talented in the Restorative theme are adept at dealing with problems. They are good at figuring out what is wrong and resolving it.",
    i_am: "not intimidated by points of pain or dysfunction",
    i_will: "look for the bug in the system, diagnose what ails",
    i_love: "finding solutions",
    i_dislike: "the idea that problems will disappear if they are ignored",
    i_bring: "courage and creativity to problematic situations",
    i_need: "problems that must be solved",
    metaphor_image: "Medical model",
    barrier_label: "perceived as negative because of association with problems",
    text_contrast_one: "Restorative: Trouble-shooter. / Strategic: Map-maker. ",
    text_contrast_two:
      "Restorative: I intentionally invade problem areas to restore the original state. / Positivity: I intentionally evade problem areas to maintain my emotional state."
  },
  31 => %{
    name: "Self-Assurance",
    domain: "I",
    description:
      "People exceptionally talented in the Self-Assurance theme feel confident in their ability to take risks and manage their own lives. They have an inner compass that gives them certainty in their decisions.",
    i_am: "internally confident in the midst of external uncertainty",
    i_will: "seek to exert influence rather than be influenced",
    i_love: "being in control of my own destiny",
    i_dislike: "others telling me what to do",
    i_bring: "a willingness to take necessary risks",
    i_need: "freedom to act unilaterally and independently",
    metaphor_image: "Internal compass, marches to beat of different drum",
    barrier_label: "arrogant, over-confident, self-sufficient",
    text_contrast_one:
      "Self-Assurance: Anticipates risk so that it can be engaged and overcome. / Deliberative: Anticipates risk so that it can be avoided and minimized. ",
    text_contrast_two: "Self-Assurance: Certainty. / Learner: Curiosity."
  },
  32 => %{
    name: "Significance",
    domain: "I",
    description:
      "People exceptionally talented in the Significance theme want to make a big impact. They are independent and prioritize projects based on how much influence they will have on their organization or people around them.",
    i_am:
      "interested in being seen as significant so that I can accomplish something significant",
    i_will: "be motivated and influenced by the perceptions of others",
    i_love: "associating with successful people",
    i_dislike: "being invisible to or ignored by others",
    i_bring: "a desire for wanting more",
    i_need: "an appreciative audience that will bring out my best",
    metaphor_image:
      "Natural performer who is comfortable with the visibility of center stage/bright lights",
    barrier_label: "attention hound, showboat",
    text_contrast_one:
      "Significance: I want to be admired so I must do something admirable. / Woo: I want to win others over so I must be winsome. ",
    text_contrast_two:
      "Significance: To be seen and heard is my desire. / Deliberative: To watch and listen is my desire."
  },
  33 => %{
    name: "Strategic",
    domain: "T",
    description:
      "People exceptionally talented in the Strategic theme create alternative ways to proceed. Faced with any given scenario, they can quickly spot the relevant patterns and issues.",
    i_am: "willing to consider all the possibilities so the best isn’t missed",
    i_will: "find the best route moving forward",
    i_love: "seeing a way when others assume there is no way",
    i_dislike: "doing things the way we have always done them",
    i_bring: "creative anticipation, imagination, persistence",
    i_need: "freedom to make midcourse corrections",
    metaphor_image: "Great peripheral vision — can see the whole field",
    barrier_label: "always has to try something different",
    text_contrast_one:
      "Strategic: Natural evaluator of possibilities. / Analytical: Natural evaluator of realities. ",
    text_contrast_two:
      "Strategic: Considers alternative routes. / Focus: Concentrates on a singular destination."
  },
  34 => %{
    name: "Woo",
    domain: "I",
    description:
      "People exceptionally talented in the Woo theme love the challenge of meeting new people and winning them over. They derive satisfaction from breaking the ice and making a connection with someone.",
    i_am: "socially fast and outgoing",
    i_will: "take the social initiative",
    i_love: "meeting someone I haven’t met before",
    i_dislike: "a static or shrinking social network",
    i_bring: "energy to social situations",
    i_need: "social variability",
    metaphor_image: "Hand-shaking politicians building their constituency",
    barrier_label: "phony, superficial",
    text_contrast_one:
      "Woo: Can build a broad social network. / Relator: Can build a deep social network. ",
    text_contrast_two: "Woo: Winning others over. / Competition: Winning over others."
  }
}

theme_records =
  Enum.map(themes, fn {_, attrs} ->
    contrasts = Map.take(attrs, [:text_contrast_one, :text_contrast_two])
    attrs = Map.drop(attrs, [:text_contrast_one, :text_contrast_two])

    {:ok,theme} = Themes.create_theme(attrs)

    {theme, contrasts}
  end)

Enum.each(theme_records, fn {theme, contrasts} ->
  Enum.each(contrasts, fn
    {_, phrase} ->
      # Format: "ThemeName: ... / ContrastName: ..."
      [_theme_phrase, contrast_phrase] = String.split(phrase, "/")

      contrast_name =
        contrast_phrase
        |> String.trim()
        |> String.split(":")
        |> hd()

      contrast_talent = Repo.get_by!(Theme, name: contrast_name)

      Themes.create_contrast(%{
        theme_id: theme.id,
        contrast_id: contrast_talent.id,
        phrase: phrase
      })
  end)
end)
