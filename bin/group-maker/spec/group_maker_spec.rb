require_relative '../group_building_utils'
require 'rspec'

RSpec.describe GroupBuildingUtils, "#repeated-pairings" do |variable|

  let (:cohort_19) do
    [[["Plouton Praxiteles", "Another Student", "Zosimos Theokleia", "Grace Hopper"], ["La Croix", "Linus Alexandra", "Euphemios Oceanus", "Medea Mercurius"], ["Democritus Agathe", "Cody McCoder", "Demetrios Isidoros", "Vita Cassian"], ["Antipatros Faunus", "Chares Rufinus", "Lucretia Tarquinius", "Group Maker"], ["Domitius Nausikaa", "A Student", "Dev Bootcamp"]], [["Zosimos Theokleia", "La Croix", "A Student", "Dev Bootcamp"], ["Linus Alexandra", "Lucretia Tarquinius", "Democritus Agathe", "Plouton Praxiteles"], ["Chares Rufinus", "Domitius Nausikaa", "Demetrios Isidoros", "Another Student"], ["Group Maker", "Cody McCoder", "Vita Cassian", "Medea Mercurius"], ["Antipatros Faunus", "Euphemios Oceanus", "Grace Hopper"]], [["Linus Alexandra", "Medea Mercurius", "Domitius Nausikaa", "Grace Hopper"], ["A Student", "Vita Cassian", "Chares Rufinus", "Lucretia Tarquinius"], ["Euphemios Oceanus", "Dev Bootcamp", "Another Student", "Zosimos Theokleia"], ["Antipatros Faunus", "Cody McCoder", "Group Maker", "La Croix"], ["Democritus Agathe", "Plouton Praxiteles", "Demetrios Isidoros"]]]
  end

  let (:cohort_23) do 
    [[["Euphemios Oceanus", "Another Student", "Hello World", "Antipatros Faunus"], ["Zosimos Theokleia", "Democritus Agathe", "Linus Alexandra", "Domitius Nausikaa"], ["Cody McCoder", "Grace Hopper", "Hot Dog", "A Student"], ["Vita Cassian", "Plouton Praxiteles", "Ruby Tuesday", "Dev Bootcamp"], ["Demetrios Isidoros", "Chares Rufinus", "La Croix", "Lucretia Tarquinius"], ["Medea Mercurius", "Group Maker", "Chicago Illinois"]], [["Democritus Agathe", "Cody McCoder", "Chicago Illinois", "Chares Rufinus"], ["A Student", "Zosimos Theokleia", "Ruby Tuesday", "Medea Mercurius"], ["Demetrios Isidoros", "Hello World", "Plouton Praxiteles", "Linus Alexandra"], ["Antipatros Faunus", "La Croix", "Vita Cassian", "Lucretia Tarquinius"], ["Euphemios Oceanus", "Grace Hopper", "Group Maker", "Domitius Nausikaa"], ["Dev Bootcamp", "Hot Dog", "Another Student"]], [["Cody McCoder", "Chicago Illinois", "Linus Alexandra", "Antipatros Faunus"], ["Democritus Agathe", "Vita Cassian", "La Croix", "Domitius Nausikaa"], ["Hot Dog", "Lucretia Tarquinius", "Another Student", "A Student"], ["Chares Rufinus", "Hello World", "Medea Mercurius", "Group Maker"], ["Plouton Praxiteles", "Dev Bootcamp", "Ruby Tuesday", "Grace Hopper"], ["Zosimos Theokleia", "Demetrios Isidoros", "Euphemios Oceanus"]]]
  end

  let (:cohort_16) do
    [[["Linus Alexandra", "Domitius Nausikaa", "Group Maker", "Ruby Tuesday"], ["Demetrios Isidoros", "Chicago Illinois", "Grace Hopper", "Hello World"], ["Dev Bootcamp", "Vita Cassian", "Cody McCoder", "La Croix"], ["Zosimos Theokleia", "Another Student", "A Student", "Hot Dog"]], [["Zosimos Theokleia", "Demetrios Isidoros", "Dev Bootcamp", "Ruby Tuesday"], ["Another Student", "Hello World", "Vita Cassian", "Linus Alexandra"], ["Grace Hopper", "A Student", "Domitius Nausikaa", "Cody McCoder"], ["Hot Dog", "Chicago Illinois", "Group Maker", "La Croix"]], [["Hello World", "Ruby Tuesday", "Cody McCoder", "Hot Dog"], ["Dev Bootcamp", "Domitius Nausikaa", "Another Student", "Chicago Illinois"], ["Demetrios Isidoros", "La Croix", "Linus Alexandra", "A Student"], ["Zosimos Theokleia", "Vita Cassian", "Group Maker", "Grace Hopper"]]]
  end

  let (:cohort_7) do
    [[["Ruby Tuesday", "A Student", "Chicago Illinois", "Hot Dog"], ["Hi There", "Hello World", "La Croix"]], [["Chicago Illinois", "A Student", "Hot Dog", "La Croix"], ["Ruby Tuesday", "Hi There", "Hello World"]], [["La Croix", "Ruby Tuesday", "Hello World", "Hi There"], ["A Student", "Chicago Illinois", "Hot Dog"]]]
  end

  context "with 19 student cohort" do
    it "counts 10 repeated pairings" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_19)
      expect( repeated_pairings.length ).to eq 10
    end

    it "scores as 20 people affected by repeated pairs" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_19)
      score = GroupBuildingUtils.extra_pairing_overall_score(repeated_pairings)
      expect( score ).to eq 20
    end

    it "scores as 0 people affected by extra soloing" do
      repeated_soloing = GroupBuildingUtils.extra_soloing(cohort_19)
      score = GroupBuildingUtils.extra_soloing_overall_score(repeated_soloing)
      expect( score ).to eq 0
    end
  end

  context "with 23 student cohort" do
    it "counts 10 repeated pairings" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_23)
      expect( repeated_pairings.length ).to eq 10
    end

    it "scores as 20 people affected by repeated pairs" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_23)
      score = GroupBuildingUtils.extra_pairing_overall_score(repeated_pairings)
      expect( score ).to eq 20
    end

    it "scores as 0 people affected by extra soloing" do
      repeated_soloing = GroupBuildingUtils.extra_soloing(cohort_23)
      score = GroupBuildingUtils.extra_soloing_overall_score(repeated_soloing)
      expect( score ).to eq 0
    end
  end

  context "with 16 student cohort" do
    it "counts 0 repeated pairings" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_16)
      expect( repeated_pairings.length ).to eq 0
    end

    it "scores as 0 people affected by repeated pairs" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_16)
      score = GroupBuildingUtils.extra_pairing_overall_score(repeated_pairings)
      expect( score ).to eq 0
    end

    it "scores as 0 people affected by extra soloing" do
      repeated_soloing = GroupBuildingUtils.extra_soloing(cohort_16)
      score = GroupBuildingUtils.extra_soloing_overall_score(repeated_soloing)
      expect( score ).to eq 0
    end
  end

  context "with 7 student cohort" do
    it "counts 8 repeated pairings" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_7)
      expect( repeated_pairings.length ).to eq 8
    end

    it "scores as 20 people affected by repeated pairs" do
      repeated_pairings = GroupBuildingUtils.extra_pairings(cohort_7)
      score = GroupBuildingUtils.extra_pairing_overall_score(repeated_pairings)
      expect( score ).to eq 20
    end

    it "scores as 2 people affected by extra soloing" do
      repeated_soloing = GroupBuildingUtils.extra_soloing(cohort_7)
      expect( repeated_soloing.length ).to eq 2
    end

    it "identifies people affected by extra soloing" do
      repeated_soloing = GroupBuildingUtils.extra_soloing(cohort_7)
      expect( repeated_soloing.keys ).to match_array ["Hello World", "Hi There"]
    end
  end

end