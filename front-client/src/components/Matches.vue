<template>
  <div>
    <h1>Matches</h1>
    <table v-if="matches">
      <thead>
        <tr>
          <th>id</th>
          <th>style</th>
          <th>game</th>
          <th>home team</th>
          <th>invited team</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="match in matches" v-on:click="showMatch(match.id)">
          <td>
            {{ match.id }}
          </td>
          <td>
            {{ match.style }}
          </td>
          <td>
            {{ match.game }}
          </td>
          <td>
            <p>{{ match.home_team_name }}</p>
            <p>{{ match.home_team_score }}</p>
          </td>
          <td>
            <p>{{ match.invited_team_name }}</p>
            <p>{{ match.invited_team_score }}</p>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>
      No matches yet
    </p>
  </div>
</template>

<script>
  import api from '../api'
  import { router } from '../main'

  export default {
    name: 'Matches',
    data () {
      return {
        matches: []
      }
    },
    mounted () {
      api.getMatches().then(response => {
        this.matches = response.data
      })
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
