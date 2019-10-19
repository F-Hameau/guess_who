# frozen_string_literal: true

RSpec.describe GuessWho do
  it 'has a version number' do
    expect(GuessWho::VERSION).not_to be nil
  end

  let(:name_and_photo) do
    {
      'François Hameau' => '/teams/francois.png',
      'David Ruyer' => '/teams/david.png',
      'Renaud Pestre' => '/teams/renaud.png'
    }
  end

  let(:session) do
    GuessWho::Session.new(name_and_photo)
  end

  it 'runs a one question the game' do
    expect(session.display_photo).to eq ['François Hameau', ['/teams/francois.png', '/teams/david.png', '/teams/renaud.png']]
    expect(session.good_answer?('/teams/francois.png')).to eq true
    expect(session.score).to eq 100
  end
end
