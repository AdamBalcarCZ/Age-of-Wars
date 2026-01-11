using UnityEngine;
using System.Collections.Generic;

[CreateAssetMenu(fileName = "NewTech", menuName = "RTS/Technology Data")]
public class TechData : ScriptableObject
{
    [Header("Info")]
    public string techName;
    [TextArea] public string description;

    [Header("Požadavky")]
    public TechData requiredTech;
    
    [Header("Cena")]
    public int costPolymer;
    public int costEnergy;

    [Header("Odměna")]
    public List<UnitData> unlocksUnits;
}