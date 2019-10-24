# frozen_string_literal: true

RSpec.describe GuessWho do
  it 'has a version number' do
    expect(GuessWho::VERSION).not_to be nil
  end

  before do
    srand(0)
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
    expect(session.display_photo).to eq ['François Hameau', ['/teams/david.png', '/teams/renaud.png', '/teams/francois.png']]
    expect(session.submit!('/teams/francois.png')).to eq true
    expect(session.score).to eq 100
  end

  it 'runs a three questions the game' do
    expect(session.display_photo).to eq ['François Hameau', ['/teams/david.png', '/teams/renaud.png', '/teams/francois.png']]
    expect(session.submit!('/teams/francois.png')).to eq true
    expect(session.score).to eq 100
    expect(session.display_photo).to eq ['Renaud Pestre', ['/teams/francois.png', '/teams/renaud.png', '/teams/david.png']]
    expect(session.submit!('/teams/francois.png')).to eq false
    expect(session.score).to eq 100
    expect(session.display_photo).to eq ['David Ruyer', ['/teams/francois.png', '/teams/david.png', '/teams/renaud.png']]
    expect(session.submit!('/teams/david.png')).to eq true
    expect(session.score).to eq 200
  end
end
