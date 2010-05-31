using System;
using System.Collections.Generic;
using System.Text;

namespace VolumeOSD
{
    public class DeviceInfo
    {
        public double Volume;
        public bool Muted;
        public DeviceInfo(double volume, bool muted)
        {
            Volume = volume;
            Muted = muted;
        }
    }
}
