try {
  Login-AzAccount

  $tenants = Get-AzTenant | Select-Object Name,Id
  Write-Output "Found $($tenants.Count) Tenants"
  $j = 0
  foreach ($tenant in $tenants)
  {
      $tenantValue = $j
      $tenantText = [string]$tenantValue + " : " + $tenant.Name  + " ( " + $tenant.Id + ")"
      Write-Output $tenantText
      $j++
  }
  Do 
  {
      [int]$tenantChoice = Read-Host -Prompt "Select tenant number & press enter"
  } 
  until ($tenantChoice -le $tenants.Count)

  $selectedTenant = "You selected Tenant ID: " + $tenants[$tenantChoice].Name + " ( " + $tenants[$tenantChoice].Id + " ) "
  Write-Output $selectedTenant
  Connect-AzAccount -Tenant $tenants[$tenantChoice].Id

  Write-output "Getting subscriptions that you have access to from $($tenants[$tenantChoice].Name) tenant"
  $subscriptions = Get-AzSubscription -TenantId $tenants[$tenantChoice].Id | Sort-Object SubscriptionName | Select-Object Name,SubscriptionId
  [int]$subscriptionCount = $subscriptions.count

  if ($subscriptionCount -eq 0) {
    Write-Output "No subscriptions found for this tenant."
    exit
  }

  Write-output "Found $subscriptionCount Subscriptions"
  $i = 0
  foreach ($subscription in $subscriptions)
  {
      $subValue = $i
      $subText = [string]$subValue + " : " + $subscription.Name + " ( " + $subscription.SubscriptionId + " ) "
      Write-output $subText
      $i++
  }
  Do 
  {
      [int]$subscriptionChoice = read-host -prompt "Select number & press enter"
  } 
  until ($subscriptionChoice -le $subscriptionCount)

  $selectedSub = "You selected " + $subscriptions[$subscriptionChoice].Name
  Write-output $selectedSub
  Set-AzContext -SubscriptionId $subscriptions[$subscriptionChoice].SubscriptionId
}
catch {
  Write-Output "An error occurred: $_"
}