/particles/smoke_continuous/fire/reactor
	width = 512
	height = 1024
	gradient = list("#ffd000", "#c34f0c", "#333333", "#808080")
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.015, 0.03)
	velocity = generator(GEN_CIRCLE, 1, 5)
	gravity = list(0, 1)
	position = generator(GEN_SPHERE, 8, 8)
	rotation = generator(GEN_NUM, -5, 5)
	scale = 2.7
	grow = 0.05
	count = 3000
	is_global = FALSE
	spawning = 5
	lifespan = 100
	fade = 40
	fadein = 25
	friction = 0.1