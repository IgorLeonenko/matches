<template>
  <div id='tournament-matches'>
    <ul v-for='round in rounds'>
      <li>
        Round number: {{round.number}}
          <div v-if="round.matches.length > 0">
            <h4>Matches in round:</h4>
            <table>
              <thead>
                <th>id</th>
                <th>status</th>
                <th>home team</th>
                <th>invited team</th>
              </thead>
              <tbody>
                <tr v-for="match in round.matches" @click="showMatch(match.id)">
                  <td>{{match.id}}</td>
                  <td>{{match.status}}</td>
                  <td>{{match.home_team_name}}</td>
                  <td>{{match.invited_team_name}}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <p v-if="round.matches.length == 0"><i>No matches assigned</i></p>
      </li>
    </ul>

  </div>
</template>

<script>
  import { router } from '../main'
  export default {
    name: 'TournamentMatches',
    props: {
      rounds: Array
    },
    methods: {
      showMatch (id) {
        router.push({name: 'showMatch', params: { id: id }})
      }
    }
  }
</script>

<style scoped>
  tbody tr:hover {
    background-color: #41b883;
  }
</style>
