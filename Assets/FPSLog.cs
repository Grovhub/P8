using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Text;

public class FPSLog : MonoBehaviour
{
    float timeTracker = 0f;
    int index = 0;
    float[] fps = new float[60];
    List<string[]> data = new List<string[]>();
    bool firstTime = true;

    // Start is called before the first frame update
    void Start()
    {
        data.Add(new string[] {"FPS"});
        InvokeRepeating("LogFPS", 10.0f, 1f);
    }

    void SaveCSVFile(string path, List<string[]> data, string delimeter = ";")
    {
        StringBuilder stringBuilder = new StringBuilder();

        foreach (string[] item in data)
        {
            stringBuilder.AppendLine(string.Join(delimeter, item));
        }

        try
        {
            StreamWriter streamWriter = File.AppendText(path);
            streamWriter.Write(stringBuilder);
            streamWriter.Close();
            Debug.Log("Saved!");
        }
        catch (Exception)
        {
            Debug.Log("Not Saved!");
            return;
        }
    }

    private void LogFPS()
    {
        if (firstTime)
        {
            timeTracker = Time.time;
            firstTime = false;
        }

        //Debug.Log(Time.time);
        if (Time.time - timeTracker <= 60.0f)
        {
            fps[index] = 1 / Time.deltaTime;
            data.Add(new string[] { Math.Round(fps[index], 1).ToString().Replace(",", ".")});
            index++;
        }
        else
        {
            CancelInvoke();
            data.Add(new string[] {Math.Round(Average(fps), 1).ToString().Replace(",", ".")});
            SaveCSVFile($"{Application.dataPath}/Vive_CSV_Files/Displacement/Huge.csv", data);
            #if UNITY_EDITOR
            EditorApplication.isPlaying = false;
            #endif
            //Application.Quit();
        }
    }

    private float Average(float[] data)
    {
        float sum = 0;
        for (int i = 0; i < data.Length; i++)
        {
            sum += data[i];
        }
        return sum/data.Length;
    }

}
