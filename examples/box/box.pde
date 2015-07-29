
import traer.physics.*;

float bigBoxSize = 200;
float littleBoxSize = 8;

float xRotation = 0;
float yRotation = 0;

float gravityMagnitude = 1;
float bounceDamp = 0.5;

int numberOfLittleBoxes = 400;

float repulsionStrength = 5;
float repulsionMinimum = 5;

ParticleSystem physics = new ParticleSystem( gravityMagnitude, 0.01 );

void setup()
{
  size( 400, 400, P3D ); 

  physics.setIntegrator( ParticleSystem.MODIFIED_EULER );

  for ( int i = 0; i < numberOfLittleBoxes; i++ )
  {
    Particle p = physics.makeParticle( 1, 
    random( -0.45*littleBoxSize, 0.45*littleBoxSize ),
    random( -0.45*littleBoxSize, 0.45*littleBoxSize ),
    random( -0.45*littleBoxSize, 0.45*littleBoxSize ) ); 


    for ( int j = 0; j < i; j++ )
    {
      Particle q = physics.getParticle( j );
      physics.makeAttraction( p, q, -repulsionStrength, repulsionMinimum );
    }
  }
}

void setRotation( float xRotate, float yRotate )
{
  physics.setGravity(  
      gravityMagnitude*sin( xRotate )*sin( yRotate ),
      gravityMagnitude*cos( xRotate ),
      -gravityMagnitude*sin( xRotate )*cos( yRotate ) 
  );
  xRotation = xRotate;
  yRotation = yRotate; 
}

void draw()
{ 
  setRotation( -0.02*(mouseY - height/2), 0.02*(mouseX - width/2) );
  
  physics.tick();
  bounce();

  background( 255 ); 

  directionalLight( 255, 255, 255, 0, 1, -1 );

  translate( width/2, height/2 );
  rotateX( xRotation );
  rotateY( yRotation );

  // Uncomment to draw the big bounding box
  //noFill();
  //stroke( 192 );
  //box( bigBoxSize );

  drawLittleBoxes();
}

void drawLittleBoxes()
{
  noStroke();
  fill( 255 );
  for ( int i = 0; i < physics.numberOfParticles(); i++ )
  {
    float t = (float)i/(physics.numberOfParticles()-1);

    pushMatrix();

    Particle p = physics.getParticle( i );
    translate( p.position().x(), p.position().y(), p.position().z() );

    box( littleBoxSize );

    popMatrix();
  }
}

void bounce()
{
  float collisionPoint = 0.5*( bigBoxSize - littleBoxSize );
  for ( int i = 0; i < physics.numberOfParticles(); i++ )
  {
    Particle p = physics.getParticle( i );

    if ( p.position().x() < -collisionPoint )
    {
      p.position().setX( -collisionPoint );
      p.velocity().setX( -p.velocity().x() );
    }
    else
      if ( p.position().x() > collisionPoint )
      {
        p.position().setX( collisionPoint );
        p.velocity().setX( -bounceDamp*p.velocity().x() );
      }

    if ( p.position().y() < -collisionPoint )
    {
      p.position().setY( -collisionPoint );
      p.velocity().setY( -bounceDamp*p.velocity().y() );
    }
    else
      if ( p.position().y() > collisionPoint )
      {
        p.position().setY( collisionPoint );
        p.velocity().setY( -bounceDamp*p.velocity().y() );
      }

    if ( p.position().z() < -collisionPoint )
    {
      p.position().setZ( -collisionPoint );
      p.velocity().setZ( -bounceDamp*p.velocity().z() );
    }
    else
      if ( p.position().z() > collisionPoint )
      {
        p.position().setZ( collisionPoint );
        p.velocity().setZ( -bounceDamp*p.velocity().z() );
      }
  } 
}


