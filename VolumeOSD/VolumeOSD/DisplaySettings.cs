using System;
using System.Collections.Generic;
using System.Text;

namespace VolumeOSD
{
    // This file contains all the XML Serializable classes.
    [Serializable]
    public class ActiveSettings
    {
        public ActiveSettings() { }

        public string Name;
        public int X;
        public int Y;
        public double Opacity;

        public static ActiveSettings Deserialize(string filepath)
        {
            System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(typeof(ActiveSettings));

            System.IO.StreamReader reader = new System.IO.StreamReader(filepath);
            ActiveSettings settings = (ActiveSettings)x.Deserialize(reader);
            reader.Close();
            return settings;
        }

        public static void Serialize(string filepath, ActiveSettings settings)
        {
            System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(typeof(ActiveSettings));

            System.IO.StreamWriter writer = new System.IO.StreamWriter(filepath);
            x.Serialize(writer, settings);
            writer.Close();

        }
    }
    [Serializable]
    public class ProgramSettings
    {
        public ProgramSettings() { }

        public string Name;
        public List<DisplaySettings> Settings;

        public static ProgramSettings Deserialize(string filepath)
        {
            System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(typeof(ProgramSettings));

            System.IO.StreamReader reader = new System.IO.StreamReader(filepath);
            ProgramSettings settings = (ProgramSettings)x.Deserialize(reader);
            return settings;
        }

    }

    [Serializable]
    public class Image
    {
        public Image() { }

        public string ImageName;
    }

    [Serializable]
    public class DisplaySettings
    {
        public DisplaySettings() { }
        public int X;
        public int Y;
        public int Width;
        public int Height;
        public int Delay;

        public List<Image> Images;
        public double Opacity;

        public static DisplaySettings Deserialize(string filepath)
        {
            System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(typeof(DisplaySettings));

            System.IO.StreamReader reader = new System.IO.StreamReader(filepath);
            DisplaySettings settings = (DisplaySettings)x.Deserialize(reader);
            return settings;
        }
    }
}
