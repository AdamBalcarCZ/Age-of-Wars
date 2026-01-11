using UnityEngine;

public class ResourceManager : MonoBehaviour
{
    public static ResourceManager Instance;

    [Header("Aktuální zdroje")]
    public int currentPolymer = 200;
    public int currentEnergy = 100;
    private void Awake()
    {
        if (Instance == null) Instance = this;
        else Destroy(gameObject);
    }

    public bool CanAfford(int polymer, int energy)
    {
        return currentPolymer >= polymer && currentEnergy >= energy;
    }

    public void SpendResources(int polymer, int energy)
    {
        if (CanAfford(polymer, energy))
        {
            currentPolymer -= polymer;
            currentEnergy -= energy;
            Debug.Log($"Utraceno. Zbývá: {currentPolymer} Polymeru, {currentEnergy} Energie.");
        }
    }

    public void AddResources(int polymer, int energy)
    {
        currentPolymer += polymer;
        currentEnergy += energy;
    }
}