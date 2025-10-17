import qs
import qs.services
import QtQuick
import "../"

OsdValueIndicator {
    id: osdValues
    // Use hardware volume when EasyEffects is active
    value: Audio.value
    icon: (HardwareAudio.ready ? HardwareAudio.hardwareMuted : Audio.sink?.audio.muted) ? "volume_off" : "volume_up"
    name: Translation.tr("Volume")
}
