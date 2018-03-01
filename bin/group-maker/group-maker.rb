require_relative 'group_building_utils'

if STDIN.tty?
  puts "group-maker expects a list of students via stdin, one student per line."
  puts "ex: ruby group-maker.rb < example.txt"
  exit(1)
end

if ARGV[0] == '-b'
  (7..42).each do |i|
    puts "Testing cohort size #{i}: "
    phase = GroupBuildingUtils.benchmark((0...i).to_a.map(&:to_s))
    puts "-----------------------"
  end
else
  students = STDIN.readlines.map(&:strip).reject(&:empty?)
  phase = GroupBuildingUtils.generate(students)
  p phase
  puts GroupBuildingUtils.score_report(GroupBuildingUtils.extra_pairings(phase), GroupBuildingUtils.extra_soloing(phase))
  puts GroupBuildingUtils.format(phase)
end
