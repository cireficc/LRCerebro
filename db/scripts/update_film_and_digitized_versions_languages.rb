Film.all.each do |film|
  film.audio_languages.map! { |al| al.titleize }
  film.subtitle_languages.map! { |sl| sl.titleize }
  film.save
end

DigitizedVersion.all.each do |dv|
  dv.audio_language = dv.audio_language.titleize
  dv.subtitle_language = dv.subtitle_language.titleize
  dv.save
end

DigitizedVersion.where(audio_language: "").update_all(audio_language: nil)
DigitizedVersion.where(subtitle_language: "").update_all(subtitle_language: nil)
