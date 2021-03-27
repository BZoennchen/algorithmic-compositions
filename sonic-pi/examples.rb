# Musik programmieren mit SonicPi
# Link: https://sonic-pi.net/
# zoennchen.benedikt@hm.edu

use_bpm 98

use_synth :sine

instruments = [
  :bd_haus, #1
  :sn_zome, #2
  :drum_cymbal_closed, #3
  :drum_cymbal_pedal,
  :drum_bass_soft,
  :drum_bass_hard
]

beats1 = [
  1,0,1,0,
  2,0,0,0,
  1,0,0,0,
  2,1,0,0
]

beats2 = [
  6,0,6,0,
  6,0,6,0,
  6,0,6,5,
  5,3,3,5
]

melody = shuffle(scale(:e4, :minor))

live_loop :pianist do
  play melody.tick, amp: 0.4
  play melody.look-12, amp: 0.3
  play melody.look-24, amp: 0.2
  sleep 0.5
end

live_loop :drummer2 do
  16.times do |i|
    sample instruments[beats1[i]-1] if beats1[i] != 0
    sleep 0.25
  end
end

live_loop :drummer1 do
  16.times do |i|
    sample instruments[beats2[i]-1] if beats2[i] != 0
    sleep 0.25
  end
end