using System;
using System.Collections.Generic;
using System.Text;
using WaveLib.AudioMixer;

namespace VolumeOSD
{
    class VolumeDetectorXP : IVolumeDetector
    {
        private AudioCallback _callback;
        private Mixers Mixers;


        public VolumeDetectorXP()
        {
            Mixers = new Mixers(true);
        }
        #region IVolumeDetector Members


        public void RegisterCallback(AudioCallback callback)
        {
            _callback = callback;
            Mixers.Playback.MixerLineChanged += new WaveLib.AudioMixer.Mixer.MixerLineChangeHandler(RunCallback);
        }

        #endregion


        private void RunCallback(Mixer mixer, MixerLine line)
        {
            int VolumeMin = Mixers.Playback.Lines[0].VolumeMin;
            int VolumeMax = Mixers.Playback.Lines[0].VolumeMax;
            int VolumeCurrent = Mixers.Playback.Lines[0].Volume;

            // Volume Min and Max are probably 0, and 100, but since I can't say that for sure adjust the values to be zero based
            VolumeMax = VolumeMax - VolumeMin;
            VolumeCurrent = VolumeCurrent - VolumeMin;
            VolumeMin = 0;

            double volume = ((double)VolumeCurrent)/((double) VolumeMax);
            bool muted = Mixers.Playback.Lines[0].Mute;

            if(_callback != null)
                _callback.Invoke(new DeviceInfo(volume, muted));
        }

    }
}
