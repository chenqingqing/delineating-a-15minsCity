; Delineating the ‘15-minute City’ Bubble model v01.nlogo
; This model simulate residential movement on streets from the bottom-up by drawing a community-bubble of a city

;GIS extension
extensions [gis]

;create different types of agents
breed [flags flag]
breed [persons person]
breed [bubbles bubble]
breed [axises axis]
breed [rings ring]

;global variable declaration
globals [
  STREETS
  BUBBLE-RADIUS
  START-PATCH
  N_PERSON
  MINUTE
  SECOND
  patch-scale
  n-current-persons
  n-died-persons
]

; declaring variables that belong to pathces
patches-own [
  POIs
  is-accessible?
  heat
]

; declaring variables that belong to persons
persons-own [
  memory
  target
  energy
]


; initialization-----------------------------------------------------------------------------------------------------------------------------
to setup
  ;; clears everything out to have a blank slate on which to start
  clear-all

  ;; initialization
  set BUBBLE-RADIUS 0
  set MINUTE 0
  set SECOND 0
  set patch-scale 4000 / world-width
  ;;loading GIS shape file ------------------------------------------------------------
  ;;store the street shapefile data in the global variable called STREET
;  set STREETS gis:load-dataset "data/streets_with_POIs/streets_with_POIs_queens2km.shp"
  set STREETS gis:load-dataset "data/streets_with_POIs/streets_with_POIs_queens2km_updated.shp"
  gis:set-world-envelope gis:envelope-of STREETS

  ;;set up patches --------------------------------------------------------------------
  ifelse Situation = "Original" [
    ifelse base-map = "show POIs" [
    ;; give number of pois to patches
    foreach  gis:feature-list-of STREETS [
      [t]->
        ask patches gis:intersecting t [
          set STREETS gis:property-value t "nrm_dvr"
          if gis:property-value t "nrm_dvr" = 0.00 [
                 set pcolor 77
                 set POIs 0.00
            ]
          if gis:property-value t "nrm_dvr" = 0.05 [
                 set pcolor 75
                 set POIs 0.05
            ]
          if gis:property-value t "nrm_dvr" = 0.39 [
                 set pcolor 86
                 set POIs 0.39
            ]
          if gis:property-value t "nrm_dvr" = 0.42 [
                 set pcolor 96
                 set POIs 0.42
            ]
          if gis:property-value t "nrm_dvr" = 0.60 [
                 set pcolor 94
                 set POIs 0.60
            ]
          if gis:property-value t "nrm_dvr" = 0.63 [
                 set pcolor 106
                 set POIs 0.63
            ]
          if gis:property-value t "nrm_dvr" = 0.76 [
                 set pcolor 104
                 set POIs 0.76
           ]
         if gis:property-value t "nrm_dvr" = 0.79 [
                 set pcolor 116
                 set POIs 0.79
           ]
         if gis:property-value t "nrm_dvr" = 0.87 [
                 set pcolor 114
                 set POIs 0.87
          ]
          if gis:property-value t "nrm_dvr" = 0.88 [
                 set pcolor 135
                 set POIs 0.88
          ]
         if gis:property-value t "nrm_dvr" = 1.00 [
                 set pcolor 125
                 set POIs 1.00
          ]
        ]
  ]
      ; give -1 value to black patches to indicate no streets
  ask patches [
    ifelse pcolor = black [
      set POIs -1
      set is-accessible? false
      ][
        set is-accessible? true
        ]
      ]
    ]
  [
    ; draw base-map
    gis:set-drawing-color red
    gis:draw STREETS 1
    foreach  gis:feature-list-of STREETS [
      [t]->
        ask patches gis:intersecting t [
          set STREETS gis:property-value t "nrm_dvr"
            if gis:property-value t "nrm_dvr" = 0.00 [
                 set is-accessible? true
                 set POIs 0.00
            ]
          if gis:property-value t "nrm_dvr" = 0.05 [
                 set is-accessible? true
                 set POIs 0.05
            ]
          if gis:property-value t "nrm_dvr" = 0.39 [
                 set is-accessible? true
                 set POIs 0.39
            ]
          if gis:property-value t "nrm_dvr" = 0.42 [
                 set is-accessible? true
                 set POIs 0.42
            ]
          if gis:property-value t "nrm_dvr" = 0.60 [
                 set is-accessible? true
                 set POIs 0.60
            ]
          if gis:property-value t "nrm_dvr" = 0.63 [
                 set is-accessible? true
                 set POIs 0.63
            ]
          if gis:property-value t "nrm_dvr" = 0.76 [
                 set is-accessible? true
                 set POIs 0.76
           ]
         if gis:property-value t "nrm_dvr" = 0.79 [
                 set is-accessible? true
                 set POIs 0.79
           ]
         if gis:property-value t "nrm_dvr" = 0.87 [
                 set is-accessible? true
                 set POIs 0.87
          ]
          if gis:property-value t "nrm_dvr" = 0.88 [
                 set is-accessible? true
                 set POIs 0.88
          ]
         if gis:property-value t "nrm_dvr" = 1.00 [
                 set is-accessible? true
                 set POIs 1.00
          ]
        ]
      ]
    ]
  ][
    ifelse base-map = "show POIs" [
    ;; give number of pois to patches
    foreach  gis:feature-list-of STREETS [
      [t]->
        ask patches gis:intersecting t [
          set STREETS gis:property-value t "rndm_n_"
          if gis:property-value t "rndm_n_" = 0.00 [
                 set pcolor 77
                 set POIs 0.00
            ]
          if gis:property-value t "rndm_n_" = 0.05 [
                 set pcolor 75
                 set POIs 0.05
            ]
          if gis:property-value t "rndm_n_" = 0.39 [
                 set pcolor 86
                 set POIs 0.39
            ]
          if gis:property-value t "rndm_n_" = 0.42 [
                 set pcolor 96
                 set POIs 0.42
            ]
          if gis:property-value t "rndm_n_" = 0.60 [
                 set pcolor 94
                 set POIs 0.60
            ]
          if gis:property-value t "rndm_n_" = 0.63 [
                 set pcolor 106
                 set POIs 0.63
            ]
          if gis:property-value t "rndm_n_" = 0.76 [
                 set pcolor 104
                 set POIs 0.76
           ]
         if gis:property-value t "rndm_n_" = 0.79 [
                 set pcolor 116
                 set POIs 0.79
           ]
         if gis:property-value t "rndm_n_" = 0.87 [
                 set pcolor 114
                 set POIs 0.87
          ]
          if gis:property-value t "rndm_n_" = 0.88 [
                 set pcolor 135
                 set POIs 0.88
          ]
         if gis:property-value t "rndm_n_" = 1.00 [
                 set pcolor 125
                 set POIs 1.00
          ]
        ]
  ]

      ; give -1 value to black patches to indicate no streets
  ask patches [
    ifelse pcolor = black [
      set POIs -1
      set is-accessible? false
      ][
        set is-accessible? true
        ]
      ]
    ]
  [
    ; draw base-map
    gis:set-drawing-color red
    gis:draw STREETS 1
    foreach  gis:feature-list-of STREETS [
      [t]->
        ask patches gis:intersecting t [
          set STREETS gis:property-value t "rndm_n_"
            if gis:property-value t "rndm_n_" = 0.00 [
                 set is-accessible? true
                 set POIs 0.00
            ]
          if gis:property-value t "rndm_n_" = 0.05 [
                 set is-accessible? true
                 set POIs 0.05
            ]
          if gis:property-value t "rndm_n_" = 0.39 [
                 set is-accessible? true
                 set POIs 0.39
            ]
          if gis:property-value t "rndm_n_" = 0.42 [
                 set is-accessible? true
                 set POIs 0.42
            ]
          if gis:property-value t "rndm_n_" = 0.60 [
                 set is-accessible? true
                 set POIs 0.60
            ]
          if gis:property-value t "rndm_n_" = 0.63 [
                 set is-accessible? true
                 set POIs 0.63
            ]
          if gis:property-value t "rndm_n_" = 0.76 [
                 set is-accessible? true
                 set POIs 0.76
           ]
         if gis:property-value t "rndm_n_" = 0.79 [
                 set is-accessible? true
                 set POIs 0.79
           ]
         if gis:property-value t "rndm_n_" = 0.87 [
                 set is-accessible? true
                 set POIs 0.87
          ]
          if gis:property-value t "rndm_n_" = 0.88 [
                 set is-accessible? true
                 set POIs 0.88
          ]
         if gis:property-value t "rndm_n_" = 1.00 [
                 set is-accessible? true
                 set POIs 1.00
          ]
        ]
      ]
    ]
  ]

  ;; set up agents------------------------------------------------------------------------
  ;setup agents: persons
  setup-persons

  ;setup agents: flags
  setup-flags

  ;setup agents: bubbles
  setup-bubbles BUBBLE-RADIUS

  if show-rings? [
    setup-axises
    setup-rings
  ]

  ;; set up histogram plots --------------------------------------------------------------
  plot-histograms

  reset-ticks ; starts the tick counter
end


; to set up agents---------------------------------------------------------------------------------------------------------------------------------
; setup agent: persons
to setup-persons
  create-ordered-persons num-person [
    set shape "person"
    set size 5
    set heading random 360
    set color yellow
    set xcor world-width / 2
    set ycor world-height / 2
    set START-PATCH patch-here ; set initial location as their initial patchdown
    set memory ( list patch-here )
    set heat 50
    set energy 100
    ; option: whether to show agent ID
    ifelse show-ID?
      [set label who]
      [set label ""]
  ]
end


; setup agent: flags
to setup-flags
   create-flags 1 [
    set shape "flag"
    set size 7
    set color red
    set xcor world-width / 2
    set ycor world-height / 2
  ]
end

; setup agent: bubbles
to setup-bubbles [r]
  create-ordered-bubbles 50 [
    set shape "circle"
    set size 2
    set color red
    set xcor world-width / 2
    set ycor world-height / 2
    fd 0
    rt 90
  ]
end

; draw background x-y axises
to setup-axises
  create-axises 1 [
    ;; draw X and Y axes
    set xcor world-width / 2
    set ycor world-height / 2
    set heading 0
    set color 8
    set shape "line"
    set size world-height
    stamp
    rt 90
    set size world-width
    stamp
    die
  ]
end

; draw background rings
to setup-rings
  ; draw background rings
  let n_ring ceiling (world-width * sqrt 2 / (ring-radius * 2) )
  create-rings n_ring [
    set xcor world-width / 2
    set ycor world-height / 2
    set color 8
    set shape "ring"
    set size ring-radius * 2 * (who - 154)
    stamp
    die
  ]
end




; movement --------------------------------------------------------------------------------------------------------------------
to go
  ;set timing--------------------------------------------------------
  set SECOND SECOND + 10
  if SECOND = 60 [
    set MINUTE MINUTE + 1
    set SECOND 0
  ]


  ;set movement-----------------------------------------------------
  ask persons [
    random-walk ; agent do random walk
    set heat 50 ; give heat to patches
    reproduce
  ]

  diffuse heat 1
  ; options for measure bubble radius-------------------------------
  ifelse distance-type = "density" [
    ; calculate bubble radius based on the most density agent
    ; most density agent is the agent with most number of agents within chosed distance
    let peak-density-person max-one-of persons [ count persons with [ distance myself < density-distance] ]
    set BUBBLE-RADIUS [distance start-patch] of peak-density-person

  ] [
    ; calculate bubble radius based on the average distance of all agents
    set BUBBLE-RADIUS mean [distance START-PATCH] of persons
  ]

  ; draw bubble-----------------------------------------------------
  draw-bubble BUBBLE-RADIUS
  display
  ; reports the current value of the tick counter------------------
  tick
end



; random walk --------------------------------------------------------------------------------------------------
to random-walk
  ; search for target
  turn-until-satisfy 0
  ; move to target
  move-to target
  ; record the visited patches
  set memory lput patch-here memory

  ; switch: to decide whether show the patches visited
  if show-path? [ ifelse path-type = "no diffusion"
    [ask patch-here [ set pcolor white ]]  ; to show what is visited
    [ask patch-here [ set pcolor scale-color violet heat 0 20]]  ; to show what is visited
    ]

  ; update person color
  ifelse distance START-PATCH < BUBBLE-RADIUS [set color yellow] [set color orange]

  ; count the number of people within the bubble
  set N_PERSON count persons in-radius BUBBLE-RADIUS

  ifelse ([POIs] of target > 0) [set energy energy + [ POIs ] of target * energy-gained] [set energy energy - energy-lost]
  ;ifelse ([POIs] of target > 0) [set energy energy + [ POIs ] of target * 20] [set energy energy - 0.5]

  if energy < 0 [ die ]
  set n-current-persons count persons
  set n-died-persons (num-person - n-current-persons)
end


to reproduce
  if n-current-persons < num-person [
    hatch-persons n-died-persons [
    set xcor world-width / 2
    set ycor world-height / 2
    set energy 50
  ]
  ]
end




to turn-until-satisfy [ n ]

  ; to find the target with the higeset value of POIs
  find-target
  ; check whether the target is accessible or not, if not, find another target
  while [not can-go?] [
    rt random 360 find-target
  ]
  ; assign memeory
  let seen? member? target memory
  ; check whether the target has been visited or not
  if n < 8 [
    if seen? [rt 45 turn-until-satisfy n + 1]
  ]
end


to find-target
  let towards-parth patch-ahead 1
  let left45-patch patch-left-and-ahead 45 1
  let left90-patch patch-right-and-ahead 90 1

  let right45-patch patch-right-and-ahead 45 1
  let right90-patch patch-right-and-ahead 90 1

  set target towards-parth
  ifelse [ POIs ] of target < [ POIs ] of left45-patch [ set target left45-patch] [
    ifelse [ POIs ] of target < [ POIs ] of left90-patch [ set target left90-patch] [
      ifelse [ POIs ] of target < [ POIs ] of right45-patch [ set target right45-patch] [
        ifelse [ POIs ] of target < [ POIs ] of right90-patch [ set target right90-patch] [ set target target ]
      ]
    ]
  ]
end


to-report can-go?
  report [ is-accessible? ] of target = true
end

; to draw bubble --------------------------------------------------------------------------------------------------
to draw-bubble [r]
  ask bubbles [
    fd (pi * r / 180) * 20
    rt 20
  ]
end

; to plot histograms--------------------------------------------------------------------------------------------------
to plot-histograms
  ; distance within the bubble
  let in-distance [distance START-PATCH] of persons with [ distance START-PATCH < BUBBLE-RADIUS ]
  ; distance outside the bubble
  let out-distance [distance START-PATCH] of persons with [ distance START-PATCH > BUBBLE-RADIUS ]

  ; setup plot
  set-histogram-num-bars 20
  set-plot-pen-mode 1
  set-current-plot "Distance distribution"

  ; draw inside histogram
  create-temporary-plot-pen "Inside"
  histogram in-distance

  ; draw outside histogram
  create-temporary-plot-pen "Outside"
  histogram out-distance
end
@#$#@#$#@
GRAPHICS-WINDOW
355
60
1113
819
-1
-1
3.0
1
10
1
1
1
0
1
1
1
0
249
0
249
0
0
1
ticks
30.0

BUTTON
53
567
146
602
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
247
567
337
603
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
208
100
342
133
num-person
num-person
0
1000
500.0
1
1
NIL
HORIZONTAL

MONITOR
1126
216
1273
261
Actual bubble radius (m)
precision ((mean [distance start-patch] of persons ) * patch-scale) 3
17
1
11

PLOT
1125
280
1403
539
Bubble Radius
Time
Radius
0.0
100.0
0.0
20.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot BUBBLE-RADIUS"

PLOT
1411
547
1697
816
# of people in bubble
Time
Count
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot N_PERSON"

MONITOR
1126
104
1212
149
MINUTE
MINUTE
17
1
11

MONITOR
1219
104
1305
149
SECOND
SECOND
17
1
11

BUTTON
154
567
241
603
Move
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
207
142
341
175
show-ID?
show-ID?
1
1
-1000

PLOT
1410
281
1697
539
Distance distribution
Distance
Count
0.0
100.0
0.0
100.0
false
true
"" ""
PENS
"Inside" 1.0 1 -7171555 true "" "histogram [distance START-PATCH] of persons with [ distance START-PATCH  < BUBBLE-RADIUS ]"
"Outside" 1.0 1 -955883 true "" "histogram [distance START-PATCH] of persons with [ distance START-PATCH > BUBBLE-RADIUS ]"

SLIDER
211
754
338
787
density-distance
density-distance
0
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
207
314
340
347
show-path?
show-path?
1
1
-1000

CHOOSER
212
678
339
723
distance-type
distance-type
"density" "average"
1

PLOT
1124
546
1406
816
S.D. Distance
Time
S.D.
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "plot standard-deviation [distance START-PATCH] of persons"

CHOOSER
206
354
339
399
path-type
path-type
"diffusion" "no diffusion"
1

SWITCH
208
234
340
267
show-rings?
show-rings?
1
1
-1000

SLIDER
207
274
339
307
ring-radius
ring-radius
0
100
50.0
1
1
NIL
HORIZONTAL

CHOOSER
207
182
340
227
base-map
base-map
"show POIs" "hide POIs"
0

MONITOR
1281
216
1440
261
Actual S.D. Distance (m)
precision ((standard-deviation [distance START-PATCH] of persons) * patch-scale) 3
17
1
11

TEXTBOX
59
103
202
146
Please choose the number of people (default = 100): 
11
0.0
1

TEXTBOX
577
24
964
58
Delineating a ‘15-Minute City’
23
0.0
1

TEXTBOX
58
144
200
174
Do you wanna show people's IDs?
11
0.0
1

TEXTBOX
59
192
200
224
Which you wanna show POIs value?\n
11
0.0
1

TEXTBOX
58
239
208
267
Do you wanna show rings on the background?
11
0.0
1

TEXTBOX
58
309
208
351
Do you wanna paint the path that people have walked through?
11
0.0
1

TEXTBOX
57
361
194
389
How do you wanna paint the path?
11
0.0
1

TEXTBOX
58
546
343
574
===============================
11
0.0
1

TEXTBOX
62
64
161
86
Pre-setup
18
0.0
1

TEXTBOX
59
84
346
112
---------------
11
0.0
1

TEXTBOX
56
616
340
644
===============================
11
0.0
1

TEXTBOX
59
274
209
302
How large the rings?\n(default radius = 50)
11
0.0
1

TEXTBOX
55
633
205
655
Draw the Cicle
18
0.0
1

TEXTBOX
54
650
338
678
------------------------
11
0.0
1

TEXTBOX
52
672
203
728
How do you wanna draw the circle?\n(default uses the verage walking distance)
11
0.0
1

TEXTBOX
52
750
202
792
If you choose 'density', please choose the focus range:
11
0.0
1

TEXTBOX
51
801
346
829
===============================
11
0.0
1

TEXTBOX
1124
62
1274
84
Walking time
18
0.0
1

TEXTBOX
1125
83
1275
101
-------------------
11
0.0
1

TEXTBOX
1126
175
1276
197
Outputs
18
0.0
1

TEXTBOX
1127
195
1277
213
------------
11
0.0
1

TEXTBOX
1126
157
1463
185
===================================
11
0.0
1

CHOOSER
202
492
341
537
Situation
Situation
"Original" "Random"
1

TEXTBOX
55
505
205
523
Choose a situation:
11
0.0
1

SLIDER
205
407
339
440
energy-gained
energy-gained
0
100
20.0
1
1
NIL
HORIZONTAL

TEXTBOX
55
407
205
449
How much energy does an agent gain every time step?
11
0.0
1

TEXTBOX
54
450
204
478
How much energy does an agent lost every time step?
11
0.0
1

SLIDER
204
450
340
483
energy-lost
energy-lost
0
10
0.5
0.5
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

<div style="text-align: justify"> 

The recent uptake of ‘15-Minute City’ planning ideas is sought after by cities around the world. One of the hallmarks of this notion is to create high quality of life in cities within a short distance. The notion has been sharply discussed lately during the Covid-19 pandemic, as the pandemic has significantly restricted human movements. However, the benchmark of defining a '15-Minute City' has yet reached a consensus due to the heterogeneous urban structures across countries and places. The model introduced here is an Agent-Based Model integrated with GIS, which is uded to quantify the size of a ‘15-Minute City’. Such a model could help detect the flexibility of defining a ‘15-minute city’ and thereafter assist in investigating the underlying factors that affect its definition.
</div>

## HOW IT WORKS


<div style="text-align: justify"> 

There are three types of agents - persons, flag, and bubble. 

- **Persons**: represent residents who lived in the study area, and they perform random walks on the streets. Each person owns specific attributes, including target, memory, energy, and heat. The target refers to the street a person is going to walk to at each time step. Every time residents visit the streets, they store the visited streets into their memory vaults, which are used in the decision-making step during the simulation. The energy reveals a person’s enthusiasm to keep walking. The more energy a person own, the more enthusiastic the person wants to keep walking. In addition, every person has a fixed heat, which can be passed to streets when walking by indicating the carbon footprints. This attribute is solely triggered when users want to observe the walking paths of residents.

- **Flag**: represents the start point of the random walks, which is set at the geographical center of the study area. 

- **Bubble**: draws the bubble identified in the model. 

At model initialization, persons and flag are placed in the geographical centre of the environment.

<br/>


When the simulation begins, persons start randomly walking along the streets. At each time step (i.e., 10s), each agent needs to determine where to go according to a decision tree set in the model. More specifically speaking, an agent intends to walk on streets with a relatively high diversity of POIs, so the agent seeks the street with the highest diversity of POIs in front of itself (i.e., the target) and checks whether the target is accessible or not. If it is accessible, the agent proceeds to walk to the target and memorizes it; otherwise, the agent needs to make a random direction change and repeat the previous step until it finds a target satisfied. Every time the agent move, it either gains or lost a certain amount of energy, depending on the diversity of the POIs of the street visited. If a visited street has no POIs, the agent loses a certain amount of energy. Contrastly, if a visited street owns POIs, the agent gains a certain amount of energy, where the amount varies with the diversity. The higher the diversity is, the more energy the agent gains. Once an agent runs out of its energy, it dies, which indicates the agent gets boring and returns home. In the meanwhile, a new agent is created and placed at the start point.

<br/>

Simultaneously, the model computes the distance as the radius for drawing the bubble. The computed result is sent to the bubble agent who plays the role of drawing the local community-life circle. 

</div>



## HOW TO USE IT

<div style="text-align: justify">


**Pre-setup**: this section allows you to customize the values/conditions of variables used at model initialization. 

- **num_person**: controls the size of population in the model, ranging from 0 to 1000. 
- **show-ID?**: determines whether to show IDs of agents during the simulation. 
- **base-map**: 
	- _show POIs_: the default setting, where the street networks are colored based on the diversity of POIs.
	- _hide POIs_: the alternative setting, where the street networks are the same color but the infomation of diversity of POIs is still attached to each streets.
- **show-rings**: decides whether to show the rings in the background, which is designed to observe the regional population density (Still under development).
- **ring-radius**: controls the size of rings shown in the background. 
- **show-path**: determines whether to show agents' walking paths during the simulaiton. 
- **path-type**: controls how to show the walking paths during the simulation. 
	- _diffusion_: raw the agents' walking paths with heat diffusion. Agents pass their heat to streets when walking by, which is designed to indicates the carbon footprints.
	- _no diffusion_: simply draw the agents' walking paths
- **Situation**: model experiments with different spatial distribution of diversity of POIs
	- _Original_: the real diversity of POIs 
	- _Random_: the randomly generated diversity of POIs 

After customizing the variables, press _Setup_ buttom to complete the model initialization. 

**Draw the Bubble**: this section allows you to choose the methods for computing the walking distance.

- **distance-type**: controls the approach of distance measurement (default type is the average)
    	- _average_: measures the average distance of all persons on the streets.
   	- _density_: measures the walking distance between the start point to the most density person, which refers to the agent with the highest population density around it within a specific range (this range is controled by the **density-distance** slider below). This approach is designed to circumvent the potential impacts of outliers on distance measurement. 

- **density-distance**: controls the range of population density around an agent

Press the _Go_ buttom to start the simulation. 

**Walking time**: this section records the walking time of agents. 

**Outputs**: this section shows the output of the simulation, including the actual bubble radius, the actual standard deviation of distance and the visualization of bubble radius, distance distribution of agents, standard deviation of distance as well as the number of agents inside the bubble. 

<br/>

</div>


## THINGS TO NOTICE

<div style="text-align: justify">

- When you press the _Setup_ button, it takes a while for the model initialization. Please be patient for this step. :) 

- The model dose not set the stop time. You need to press _Go_ again to stop the simulation. 


## THINGS TO TRY

- Try different size of the population 
- Try different situation to observe how agents walking along the streets 
- Try to show the walking paths during the simulation


## EXTENDING THE MODEL

<div style="text-align: justify"> 

- Adds agents' features to present the heterogeneous population, such as the demographic characteristics, socio-economic status, heterogeneous motivations and expectations, etc.
- Adds more indicators to improve the real natural environmental conditions, such as usefulness, safety, comfort, appearance, accessibility, etc. 
- Adds social interactions amongst agents
- Adds more maps to compare different cities or places
- ...

</div>

## NETLOGO FEATURES

<div style="text-align: justify"> 

During the simulation, you will see the color of agents changes dynamically depending on the location of the agents. If the agents inside the bubble, they are colored as yellow. Otherwise they are colored as orange. 

When agents use out of energy, they die and new agents are created. So you will see new agents come out from the start point after certain time. 


</div>
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

footprint human
true
0
Polygon -7500403 true true 111 244 115 272 130 286 151 288 168 277 176 257 177 234 175 195 174 172 170 135 177 104 188 79 188 55 179 45 181 32 185 17 176 1 159 2 154 17 161 32 158 44 146 47 144 35 145 21 135 7 124 9 120 23 129 36 133 49 121 47 100 56 89 73 73 94 74 121 86 140 99 163 110 191
Polygon -7500403 true true 97 37 101 44 111 43 118 35 111 23 100 20 95 25
Polygon -7500403 true true 77 52 81 59 91 58 96 50 88 39 82 37 76 42
Polygon -7500403 true true 63 72 67 79 77 78 79 70 73 63 68 60 63 65

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

ring
true
0
Circle -7500403 false true 63 63 175

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-population-average" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="100"/>
      <value value="300"/>
      <value value="500"/>
      <value value="700"/>
      <value value="900"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;average&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-population-density" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="100"/>
      <value value="300"/>
      <value value="500"/>
      <value value="700"/>
      <value value="900"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;density&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-diversity-random-average" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Situation">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;average&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-diversity-random-density" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Situation">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;density&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-diversity-original-average" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Situation">
      <value value="&quot;Original&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;average&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-diversity-original-density" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>BUBBLE-RADIUS</metric>
    <enumeratedValueSet variable="show-path?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="base-map">
      <value value="&quot;show POIs&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Situation">
      <value value="&quot;Original&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-ID?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-rings?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ring-radius">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-person">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="path-type">
      <value value="&quot;diffusion&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-type">
      <value value="&quot;density&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
