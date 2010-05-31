using System;
using System.Collections.Generic;
using System.Text;
using CoreAudioApi;

namespace VolumeOSD
{
    // Wrap the audio device information, and callback with a standard
    // object in all situations
    public class VolumeDetectorVista : IVolumeDetector
    {
        MMDeviceEnumerator devEnum;
        MMDevice defaultDevice;

        public VolumeDetectorVista()
        {
            devEnum = new MMDeviceEnumerator();
            defaultDevice =
              devEnum.GetDefaultAudioEndpoint(EDataFlow.eRender, ERole.eMultimedia);

            defaultDevice.AudioEndpointVolume.OnVolumeNotification += new AudioEndpointVolumeNotificationDelegate(this.DelegateNotification);
            
        }

        private AudioCallback _callback;


        public void RegisterCallback(AudioCallback callback)
        {
            _callback = callback;
        }


        void DelegateNotification(AudioVolumeNotificationData data)
        {
            if(_callback != null)
                _callback.Invoke(new DeviceInfo(data.MasterVolume, data.Muted));
        }

    }
}
