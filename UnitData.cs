using UnityEngine;

[CreateAssetMenu(fileName = "NewUnit", menuName = "RTS/Unit Data")]
public class UnitData : ScriptableObject
{
    [Header("Základní info")]
    public string unitName;
    public GameObject prefab;

    [Header("Statistiky")]
    public int maxHP;
    public int attackDamage;
    public float moveSpeed;

    [Header("Ekonomika")]
    public int costPolymer;
    public int costEnergy;
    public float trainTime;
}