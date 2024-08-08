# Shadertoy Shaders

Currently using the Shader Toy Extension that emulates the website

Uniforms At the moment, iResolution, iGlobalTime (also as iTime), iTimeDelta,
iFrame, iMouse, iMouseButton, iDate, iSampleRate, iChannelN with N in [0, 9] and
iChannelResolution[] are available uniforms.

Texture Input The texture channels iChannelN may be defined by inserting code of
the following form at the top of your shader

#iChannel0 "file://duck.png" #iChannel1
"https://66.media.tumblr.com/tumblr_mcmeonhR1e1ridypxo1_500.jpg" #iChannel2
"file://other/shader.glsl" #iChannel2 "self" #iChannel4 "file://music/epic.mp3"
