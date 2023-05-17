from pygame import *
from random import randint
mixer.init()
mixer.music.load('space.ogg')
mixer.music.play()
fire_sound = mixer.Sound('fire.ogg')

bullets = sprite.Group()

font.init()
font1 = font.Font(None, 80)
win  = font1.render('YOU WIN', True, (255,255,255))
lose  = font1.render('YOU LOSE', True, (180, 0,0))
font2 = font.Font(None, 36)
font3 = font.Font(None, 50)



lost = 0
score = 0



win_width =700
win_height = 500
class GameSprite(sprite.Sprite):
    def __init__ (self, player_image, player_x, player_y,size_x, size_y, player_speed):
        super().__init__()
        self.image = transform.scale(image.load(player_image),(size_x,size_y))
        self.speed = player_speed
        self.rect = self.image.get_rect()
        self.rect.x  = player_x
        self.rect.y  = player_y
    
    def reset(self):
        window.blit(self.image,(self.rect.x,self.rect.y))




class Player(GameSprite):
    def move(self):
        keys = key.get_pressed()
        if keys[K_LEFT] and self.rect.x > 5:
            self.rect.x -= 10
        if keys[K_RIGHT] and self.rect.x < win_width - 80:
            self.rect.x += 10
    def fire(self):
        bullet = Bullet('bullet.png', self.rect.centerx, self.rect.top, 15, 20, 15)
        bullets.add(bullet)
class Enemy(GameSprite):
    def move_2(self):
        self.rect.y += self.speed
        global lost
        if self.rect.y > win_height:
            self.rect.x = randint(80,win_width - 80)
            self.rect.y = 0 
            lost += 1
        
class Bullet(GameSprite):
    def move_3(self):
        self.rect.y -= self.speed
        if self.rect.y < 0:
            self.kill()







window = display.set_mode((win_width,win_height))
display.set_caption('Шутер')
background = transform.scale(image.load('galaxy.jpg'),(win_width,win_height))

life = 3
osteroids =sprite.Group()

for i in range(2):
    osteroid = Enemy('asteroid.png', randint(30, win_width - 30), -40, 80, 50, randint(1,3))
    osteroids.add(osteroid)
    

monsters = sprite.Group()
for i in range(5):
    monster = Enemy('ufo.png', randint(80, win_width - 80), -40, 80, 50, randint(1,3))
    monsters.add(monster)


rocket = Player('rocket.png', 5, win_height - 100, 80, 100, 20)
goal = 10
max_lost = 10
clock = time.Clock()
finish = False
run = True
screen=display.set_mode((0,0))
while run:
    for e in event.get():
        if e.type == QUIT:
            run  = False
        elif e.type == KEYDOWN:
            if e.key == K_SPACE:
                fire_sound.play()
                rocket.fire()
    if not finish:     
        window.blit(background,(0,0))
        rocket.reset()
        rocket.move()
        monsters.draw(window)
        bullets.draw(window)
        osteroids.draw(window)
        for i in bullets:
            i.move_3()

        for i in monsters:
            i.move_2()
        
        for i in osteroids:
            i.move_2()


        text = font2.render('Счёт: ' + str(score), 1, (255,255,255))
        window.blit(text,(10,20))
        text_lose = font2.render('Пропущенно: ' + str(lost), 1, (255,255,255))
        window.blit(text_lose,(10,50)) 
        if life == 3: 
            life1 = font3.render(str(life),1,(0, 255, 0))
        elif life == 2:
            life1 = font3.render(str(life),1,(255, 255, 0))
        else:
            life1 = font3.render(str(life),1,(255, 0, 0))

       

        kill = sprite.groupcollide(osteroids, bullets, False, True)
        

            

        collides = sprite.groupcollide(monsters, bullets, True, True)
        for c in collides:
            score += 1
            monster = Enemy('ufo.png', randint(80, win_width - 80), -40, 80, 50, randint(1,3))
            monsters.add(monster)

        if lost >= max_lost:
            finish = True
            window.blit(lose,(200,200))

        if score >= goal:
            finish = True
            window.blit(win,(200,200))
        
        if sprite.spritecollide(rocket, osteroids, False):
            finish = True
            window.blit(lose,(200,200))
        
        if sprite.spritecollide(rocket, monsters, True):
            life -= 1
        
        if life == 0:
            life1 = font3.render(str(life),1,(255, 0, 0))

            finish = True
            window.blit(lose,(200,200))
            
        window.blit(life1,(650,10))


            


        

        


        


        display.update()
    clock.tick(50)



