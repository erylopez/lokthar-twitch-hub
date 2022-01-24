class Tts
  def initialize(voice: 'Lupe')
    @voice = voice
  end

  def speak(text: 'xqcL', filename: 'default')
    @polly = Aws::Polly::Client.new(region: 'us-east-1')

    response = @polly.synthesize_speech(
      text: text,
      output_format: "mp3",
      voice_id: @voice
    )

    IO.copy_stream(response.audio_stream, "#{Rails.root}/public/#{filename}.mp3")

    return "#{Rails.root}/public/#{filename}.mp3"
  end
end
