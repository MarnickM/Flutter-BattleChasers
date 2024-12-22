using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VariablesTransfer : MonoBehaviour
{
    public string killCount;
    public List<string> bossNames = new List<string>();
    public string endScore;

    void IncreaseKilledEnemyCount(){
        int killCountInt = int.Parse(killCount);
        killCountInt++;
        this.killCount = killCountInt.ToString();
    }

    string GetKilledEnemyCount(){
        return this.killCount;
    }

    void AddBossName(string bossName){
        this.bossNames.Add(bossName);
    }

    List<string> GetBossNames(){
        return this.bossNames;
    }

    void SetEndScore(int newEndScore){
        this.endScore = newEndScore.ToString();
    }

    string GetEndScore(){
        return this.endScore;
    }

}
