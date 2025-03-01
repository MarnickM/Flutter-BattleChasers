using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using FlutterUnityIntegration;
using System;

public class GameEnd : MonoBehaviour
{
    private int endScore;
    private List<string> killedDragons = new List<string>(); // Store unique dragon IDs
    public int killCount;

    // public void ExitGame()
    // {
    //     Application.Quit();
    // }
    public void RestartScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
    public void SetEndScore(int newEndScore)
    {
        endScore = newEndScore;
    }
    public int GetEndScore()
    {
        return endScore;
    }

    public void IncreaseKillCount(){
        //Console.WriteLine("KillCount:" + killCount);

        //int killCountInt = int.Parse(killCount);
        //killCountInt++;
        //this.killCount = killCountInt.ToString();
        killCount++;
    }

    public void AddKilledDragon(string dragonID)
    {
        if (!string.IsNullOrEmpty(dragonID))
        {
            killedDragons.Add(dragonID);
        }
    }

    // Method to get the list of killed dragons
    public List<string> GetKilledDragons()
    {
        return new List<string>(killedDragons);
    }


    // Send the score and killed dragons to Flutter
    public void SendResultsToFlutter()
    {
        // Create a data object to serialize
        var results = new
        {
            score = endScore,
            killedDragons = new List<string>(killedDragons),
            count = killCount.ToString()
        };

        // Convert to JSON
        string jsonResults = JsonUtility.ToJson(results);

        // Send the JSON to Flutter
        UnityMessageManager.Instance.SendMessageToFlutter(jsonResults);
    }
}