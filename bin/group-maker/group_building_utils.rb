require 'pp'
require 'garoupa'

module GroupBuildingUtils
  extend self

  REPEATED_SOLOING_BADNESS = 5 
    # A multiplier to weigh repeated 'odd one out's more 
    # heavily than repeated pairings

  NUMWEEKS = 3
  ALGOS = [:generate_garoupa_phase, :generate_random_phase]

  def run_algo(name, students, group_size, iterations)
    best = send(name, students, group_size)
    iterations.times do |i|
      best_score = total_phase_quality_score(best)
      break if best_score == 0

      candidate = send(name, students, group_size)
      candidate_score = total_phase_quality_score(candidate)

      if candidate_score < best_score
        best = candidate
      end
    end

    best
  end

  def generate(students, group_size = 4, iterations = 1000)
    best = run_algo(ALGOS.first, students, group_size, 1)
    best_score = total_phase_quality_score(best)

    ALGOS.each do |algo|
      break if best_score == 0
      current_best = run_algo(algo, students, group_size, iterations)
      current_score = total_phase_quality_score(current_best)
      if current_score < best_score
        best = current_best
        best_score = current_score
      end
    end
    best
  end

  def generate_garoupa_phase(students, group_size)
    w1 = Garoupa.make_groups(students,
      target_size: group_size, max_difference: 1)
    w2 = Garoupa.make_groups(students,
      target_size: group_size, max_difference: 1, past_groups: w1.groups)
    w3 = Garoupa.make_groups(students,
      target_size: group_size, max_difference: 1, past_groups: (w1.groups+w2.groups).uniq)

    [w1.groups, w2.groups, w3.groups]
  end

  def generate_random_phase(students, group_size)
    phase = []
    NUMWEEKS.times do
      phase << generate_random_week(students.shuffle, group_size)
    end
    phase
  end

  def generate_random_week(students, group_size)
    week = students.shuffle.each_slice(group_size).to_a
    if students.length % group_size != 0
      small_group = find_shortest(week)
      if small_group.length < 3
        week.delete(small_group)
        until small_group.empty?
          find_shortest(week).push(small_group.pop)
        end
      end
    end
    week
  end

  def benchmark(students, group_size = 4)
    scores = {}
    ALGOS.each do |algo|
      best = run_algo(algo, students, group_size, 1000)
      scores[algo] = extra_pairing_overall_score(extra_pairings(best))
    end

    pp scores
    winner = scores.max{|a,b| b[1] <=> a[1]}[0]
    puts "winner #{winner}"
  end

  def find_shortest(arr)
    arr.min{|a, b| a.length <=> b.length }
  end

  def total_phase_quality_score(phase)
    excessive_pairings = extra_pairings(phase)
    excesive_soloings = extra_soloing(phase)
    extra_pairing_overall_score(excessive_pairings) 
      + extra_soloing_overall_score(excesive_soloings) * REPEATED_SOLOING_BADNESS
  end

  def extra_pairing_overall_score(repeated_pair_info)
    repeated_pair_info.values.reduce(0, :+)
  end

  def extra_pairings(phase)
    scores = Hash.new { |h,k| h[k] = 0 }
    phase.each do |week|
      week.each do |group|
        group.combination(2).each do |pair|
          scores[pair.sort.join(" & ")] += 1
        end
      end
    end
    scores.select {|people, times_paired| times_paired > 1}
  end

  # It's fine to be in an odd group (and thus need to solo an extra day)
  # once per phase, but we should avoid this happening to the same 
  # student(s) multiple times per phase. This metric is even more important
  # than repeated pairings.
  #
  # This method returns an integer representing the number of times any 
  # student has exceeded their "one odd group week" limit

  def extra_soloing(phase)
    times_in_odd_group = Hash.new { |h,k| h[k] = 0 }
    phase.each do |week|
      week.each do |group|
        if group.length % 2 == 1 
          badness = 1
          group.each do |student|
            # it is extra bad if this is a 3 person group and this 
            # student has already been in an odd group
            badness = 2 if group.length == 3 && times_in_odd_group[student] > 1
            times_in_odd_group[student] += badness
          end
        end
      end
    end

    times_in_odd_group.select {|student, odd_experiences| odd_experiences > 1}
  end

  def extra_soloing_overall_score(extra_soloers)
    extra_soloers.values.reduce(0, :+)
  end

  def format(phase)
    str = ""
    phase.each_with_index do |week, i|
      str << "## Week #{i+1}\n"
      week.each_with_index do |group, j|
        str << "#{j+1}. (#{group.size}) #{group.join(", ")}\n"
      end
      str << "\n\n"
    end
    str
  end

  def score_report(extra_pairs, repeated_soloers)
    puts "Group score: #{extra_pairs.length} repeated pairings."
    puts "#{repeated_soloers.length} students are in odd groups more than once.\n\n"

    if extra_pairs.length > 0
      extra_pairs.each do |pair, count|
        puts "  #{pair}: #{count}"
      end
      puts "\n\n"
    end

    if repeated_soloers.length > 0
      repeated_soloers.each do |student, count|
        puts "  #{student}: #{count}"
      end
      puts "\n\n"
    end
  end
end